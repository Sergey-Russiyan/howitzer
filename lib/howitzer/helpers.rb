def sauce_driver?
  settings.driver.to_sym == :sauce
end

def testingbot_driver?
  settings.driver.to_sym == :testingbot
end

def selenium_driver?
  settings.driver.to_sym == :selenium
end

def ie_browser?
  ie_browsers = [:ie, :iexplore]
  if sauce_driver?
    ie_browsers.include?(settings.sl_browser_name.to_sym)
  elsif testingbot_driver?
    ie_browsers.include?(settings.tb_browser_name.to_sym)
  elsif selenium_driver?
    ie_browsers.include?(settings.sel_browser.to_sym)
  end
end

def ff_browser?
  ff_browsers = [:ff, :firefox]
  if sauce_driver?
    ff_browsers.include?(settings.sl_browser_name.to_sym)
  elsif testingbot_driver?
    ff_browsers.include?(settings.tb_browser_name.to_sym)
  elsif selenium_driver?
    ff_browsers.include?(settings.sel_browser.to_sym)
  end
end

def chrome_browser?
  chrome_browser = :chrome
  if sauce_driver?
    settings.sl_browser_name.to_sym == chrome_browser
  elsif testingbot_driver?
    settings.tb_browser_name.to_sym == chrome_browser
  elsif selenium_driver?
    settings.sel_browser.to_sym == chrome_browser
  end
end

def app_url
  prefix = settings.app_base_auth_login.blank? ? '' : "#{settings.app_base_auth_login}:#{settings.app_base_auth_pass}@"
  app_base_url prefix
end

def app_base_url(prefix=nil)
  "#{settings.app_protocol || 'http'}://#{prefix}#{settings.app_host}"
end  

def duration(time_in_numeric)
  secs = time_in_numeric.to_i
  mins = secs / 60
  hours = mins / 60
  if hours > 0
    "[#{hours}h #{mins % 60}m #{secs % 60}s]"
  elsif mins > 0
    "[#{mins}m #{secs % 60}s]"
  elsif secs >= 0
    "[0m #{secs}s]"
  end
end

def ri(value)
  raise value.inspect
end

class String
  def open(*args)
    as_page_class.open(*args)
  end

  def given
    as_page_class.new
  end

  def as_page_class
    Object.const_get("#{self.capitalize}Page")
  end
end
