module AppiumHelper

  def element(element_name, locator, timeout = 15, error = true)
    send(:define_method, element_name) do
      begin
        wait_for_element(locator, timeout)
      rescue Appium::Core::Wait::TimeoutError
        if error
          raise "Could not find element using '#{locator.first.key}=#{locator.first.key}' strategy"
        end
      end
    end
  end

  def elements(element_name, locator, error = false)
    send(:define_method, element_name) do
      begin
        driver.find_elements(locator)
      rescue Appium::Core::Wait::TimeoutError
        raise "Could not find any elements using '#{locator.first.key}=#{locator.first.key}' strategy"
      end
    end
  end

  def take_screenshot(scenario)
    time = "#{Time.new.day}-#{Time.new.month}-#{Time.new.year}"
    Dir.mkdir('report') unless Dir.exist?('report')

    result = ('fail' if scenario.failed?) || 'success'
    name = scenario.name.tr(' ', '_').downcase

    driver.screenshot("./report/#{result}_#{time}_#{name}.png")
    embed("./report/#{result}_#{time}_#{name}.png", 'image/png')
  end

  def wait_for_element(locator, timeout = 15)
    hide_keyboard
    wait = Selenium::WebDriver::Wait.new(timeout: timeout, interval: 3)
    if locator.is_a?(Selenium::WebDriver::Element)
      begin
        wait.until {locator.displayed?}
        return locator
      rescue Selenium::WebDriver::Error::NoSuchElementError
        raise 'Element for provided element object was not found!'
      end
    else
      begin
        wait.until {driver.find_element(locator.keys.first.to_sym, locator[locator.keys.first])}
      rescue Selenium::WebDriver::Error::TimeoutError
        raise "Element for provided locator: #{locator[locator.keys.first].to_s} was not found! - Time Out Error"
      rescue Selenium::WebDriver::Error::NoSuchElementError
        raise 'Element for provided locator was not found! - No such element Exception'
      end
    end
  end

  def tap_element(element)
    element = wait_for_element(element)
    Appium::TouchAction.new(driver).tap(element: element).perform
  end

  def clear_and_send(element, value)
    # element.clear
    element.send_keys(value)
  end

  def validate_alert(title, message, retries = 4)
    alert_displayed = false
    until alert_displayed
      begin
        alert = driver.switch_to.alert
        alert.accept
        return 'success'
      rescue Selenium::WebDriver::Error::UnknownError
        p 'Alert not found. Retrying..'
      rescue Selenium::WebDriver::Error::NoAlertPresentError
        p 'Alert not found. Retrying..'
      rescue Selenium::WebDriver::Error::NoSuchAlertError
        p 'Alert not found. Retrying..'
      end
      alert_displayed = false
      sleep(1)
      retries -= 1
      if retries == 0
        p 'Alert not found, permissions might already be present. Or Alert is not expected at this point.'
        return 'failure'
      end
    end
  end

  def hide_keyboard
    # keyboard_status = driver.execute_script("mobile: shell", {"command" => "dumpsys input_method | grep mInputShown"})
    # display_status = keyboard_status.strip!.split("=").last
    retries = 3
    success = false
    until success
      begin
        return true if retries == 0
        driver.hide_keyboard if driver.is_keyboard_shown
        success = true
      rescue Selenium::WebDriver::Error::UnknownError
        retries -= 1
        p 'Could not hide keyboard. Retrying...'
        success = false
      end
    end
  end


  def scroll_cell(cell)
    cell_height = cell.size.height
    cell_y_coordinate = cell.location.y
    cell_x_coordinate = cell.location.d
    Appium::TouchAction.new(driver).swipe(start_x: cell_x_coordinate, start_y: cell_y_coordinate, end_x: cell_x_coordinate, end_y: cell_y_coordinate - cell_height / 2, duration: 300).perform
  end

  def validate_presence(element)
    expect(element.displayed?).to be_truthy
  end

  def perform_small_scroll
    size = @driver.window_size

    start_y = size.height / 2
    end_y = size.height / 4

    opts_swipe = {
        :start_y => start_y,
        :end_y => end_y,
        :duration => 1000
    }
    Appium::TouchAction.new(driver).swipe(opts_swipe).perform
  end

  def perform_vertical_scroll(element)
    y = element.location.y
    x = element.location.x
    height = element.size.height
    width = element.size.width

    opts_swipe = {
        :start_y => y + (height / 2),
        :start_x => x + (width / 2),
        :end_y => 0,
        :end_x => x + (width / 2),
        :duration => 500
    }
    Appium::TouchAction.new(driver).swipe(opts_swipe).perform
  end

end
