require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

class EmailReader
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'test_app'.freeze
  CREDENTIALS_PATH = 'credentials.json'.freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
  TOKEN_PATH = 'token.yaml'.freeze
  SCOPE = 'https://mail.google.com/'

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def self.authorize(account)
    client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    credentials = authorizer.get_credentials(@user_id, SCOPE)

    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
      code = DATA['gmail'][account]
      credentials = authorizer.get_and_store_credentials_from_code(user_id: @user_id, code: code, base_url: OOB_URI)
    end
    credentials
  end

# Initialize the API
  def self.init_api(account)
    @service = Google::Apis::GmailV1::GmailService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize(account)
  end

  def self.retrieve_otp_string(account)
    @user_id = DATA["#{account}-app"]['valid']['Login Email']
    @base_user_id = DATA['gmail']['base_email']
    metadata_headers = ['Delivered-To', 'Subject']
    init_api(account)
    email_list = @service.list_user_messages(@base_user_id, q: "to:#{@user_id}", include_spam_trash: false, max_results: 5)
    if email_list.messages.nil?
      return 'Failure'
    end

    email_list.messages.each do |message|
      id = message.id
      this_message = @service.get_user_message(@base_user_id, id, format: 'metadata', metadata_headers: metadata_headers)
      receiver = this_message.payload.headers[0].value
      subject = this_message.payload.headers[1].value
      date_received = Time.at(this_message.internal_date / 1000)

      # TODO: Change the matching condition here as needed.
      if (subject.casecmp('Your verification code') == 0 || subject.casecmp('Dein Verifizierungscode') == 0) && ((date_received - Time.now).abs / 60) <= 120
        p "Found a message. #{id} sent to: #{receiver}"
        otp = this_message.snippet.scan(/\d+/).first
        @service.trash_user_message(@base_user_id, id)
        @service.delete_user_message(@base_user_id, id)
        p "Retrieved OTP and Deleted message #{id}"
        return otp
      else
        return 'Failure'
      end
    end

  end

  def self.retrieve_otp(type)
    found = false
    retries = 5
    otp_retrieved = nil
    until found
      if retries > 0
        p 'Retrying to retrieve OTP Email.'
        otp_retrieved = retrieve_otp_string(type)
        unless otp_retrieved.casecmp('Failure') == 0
          found = true
        end
        sleep 2
        retries -= 1
      else
        return
      end
    end
    return otp_retrieved
  end
end


