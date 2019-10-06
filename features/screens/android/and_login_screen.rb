require_relative '../base/base_login_screen'
module Android
  class LoginScreen < BaseLoginScreen
    element :email_input, {id:'textInputEditTextEmail'}
    element :pwd_input, {id:'textInputEditTextPassword'}
    element :submit_btn, {id:'appCompatButtonLogin'}
    element :register_link, {id: 'textViewLinkRegister'}

    def initialize
      super(email_input, pwd_input, submit_btn, register_link)
    end
  end
end
