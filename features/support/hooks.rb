# TODO: Enable later to work with latest screenshot implementation
# After do |scenario|
#   take_screenshot(scenario)
#   begin
#     driver.quit
#   rescue Exception
#     p 'Driver session was not closed, perhaps because it was never initialized.'
#     p Exception
#   end
# end

at_exit do
  #TODO: Implement here in case any action needs to be performed
  # after all tests have finished executing or if the execution fails.
end