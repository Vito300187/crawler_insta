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

    def sign_in_button_click
      click_button('Войти')
    end

    def change_language_to_ru
      find(:xpath, '//option[contains(., "Русский")]').click
    end

    def close_subscription_modal
      click_button('Не сейчас') if page.has_button?('Не сейчас')
    end

    def sigh_in
      [
        visit_home_page,
        change_language_to_ru,
        input_login,
        input_password,
        sign_in_button_click
      ].each { |act| slow_waiting_method(act) }
      close_subscription_modal
    end
  end
end
