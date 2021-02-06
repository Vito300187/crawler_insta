# frozen_string_literal: true

require 'capybara'
require 'capybara/rspec'
require 'capybara/dsl'
require 'pry'
require 'waitutil'
require 'selenium/webdriver'
require 'mouse'

Dir.glob('./pages/*.rb', &method(:require))
Dir.glob('./helpers/*.rb', &method(:require))

Capybara.register_driver :chrome do |app|
  chrome_args = []
  chrome_args << %w[disable-notifications]
  chrome_args << %w[headless disable-gpu] if ENV['HEADLESS']
  chrome_args.flatten!

  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:chromeOptions': { args: chrome_args }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities,
    clear_local_storage: true,
    clear_session_storage: true
  )
end
Capybara.configure { |config| config.default_driver = :chrome }
Capybara.javascript_driver = :chrome
Capybara.default_max_wait_time = 15
Capybara.reset_sessions!

browser_window = Capybara.page.driver.browser.manage.window
ENV['HEADLESS'] ? browser_window.resize_to(1920, 1080) : browser_window.maximize

def user_params
  YAML.safe_load(File.read('helpers/params_user.rb'))
end

def write_report(report_name, info)
  File.open(report_name, 'a+') { |f| f.puts(info) }
  puts info
end
