Before do
  if ENV['PLATFORM_NAME'].nil?
    raise 'Please define the PLATFORM_NAME environment variable like: PLATFORM_NAME=' 'android'
  else
    load_platform_modules
  end
end

at_exit do
  #TODO: Implement here in case any action needs to be performed
  # after all tests have finished executing or if the execution fails.

end