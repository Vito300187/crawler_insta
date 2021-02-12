# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara'
require 'capybara/dsl'
require 'pry'
require 'waitutil'
require 'selenium/webdriver'

Dir.glob('./pages/*.rb', &method(:require))
Dir.glob('./helpers/*.rb', &method(:require))

def user_params
  YAML.safe_load(File.read('helpers/params_user.rb'))
end

def write_report(report_name, info)
  File.open(report_name, 'a+') { |f| f.puts(info) }
  puts info
end

Capybara.register_driver :remote_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome
  caps[:browser_name] = 'chrome'
  caps[:version] = '88.0'
  caps['enableVNC'] = true
  opts = {
    browser: :remote,
    url: 'http://localhost:4444/wd/hub',
    desired_capabilities: caps
  }
  Capybara::Selenium::Driver.new(app, opts)
end

Capybara.configure do |config|
  config.default_driver = ENV['SELEN'] ? :remote_chrome : :selenium_chrome_headless
  config.javascript_driver = ENV['SELEN'] ? :remote_chrome : :selenium_chrome_headless
  config.default_max_wait_time = 10
end

RSpec.configure { Capybara.page.driver.browser.manage.window.maximize }
