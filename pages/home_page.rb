# frozen_string_literal: true

require_relative '../helpers/system_helpers'

module Pages
  class HomePage
    include Capybara::DSL
    include Helpers

    def initialize; end

    def input_login
      fill_in('username', with: LOGIN)
    end

    def input_password
      fill_in('password', with: PASSWORD)
    end

    def sigh_in
      [
        visit_home_page,
        input_login,
        input_password,
        (click_button 'Войти')
      ].each { |act| ordinary_behaviour_people(act) }
    end
  end
end
