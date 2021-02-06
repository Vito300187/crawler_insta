# frozen_string_literal: true

LOGIN = ENV['LOGIN']
PASSWORD = ENV['PASSWORD']

TAG = ENV['TAG'].nil? ? abort('Tag is not set') : ENV['TAG']
