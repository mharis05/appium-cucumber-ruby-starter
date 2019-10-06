class BaseLoginScreen
  def initialize(email_input, pwd_input, submit_btn, register_link)
    @email_input = email_input
    @pwd_input = pwd_input
    @submit_btn = submit_btn
    @register_link = register_link
  end

  def click_register
    tap_element @register_link
  end

  def enter_email(type)
    clear_and_send @email_input, DATA['user']['email']["#{type.downcase}"]
  end

  def enter_password(type)
    clear_and_send @pwd_input, DATA['user']['password']["#{type.downcase}"]
  end

end