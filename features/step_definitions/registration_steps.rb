module SharedObjects

end
World(SharedObjects)

Given(/^user is on the registration page$/) do
  byebug
  login_page = $ENV::LoginScreen.new
  login_page.click_register
end

When(/^user enters "([^"]*)" details in registration form$/) do |arg|
  pending
end

Then(/^system creates an account for the user$/) do
  pending
end