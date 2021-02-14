# frozen_string_literal: true

require_relative '../spec_helper'
require 'yaml'

module Helpers
  include Capybara::DSL
  def search_and_select_value(name)
    puts "Search -> #{name}"

    fill_in('Поиск', with: name); slow_waiting
    all(:xpath, '//span[contains(@aria-label, "Хэштег")]').first.click

    WaitUtil.wait_for_condition(
      "Tag #{name} found on page",
      timeout_sec: 10,
      delay_sec: 3
    ) { find(:xpath, "//h1[contains(., '#{name}')]") }
  end

  def visit_home_page
    visit('/')
  end

  def visit_to(link)
    puts "Visit to #{link}"
    visit link
  end

  def ordinary_user_behaviour(method)
    scroll_page; slow_waiting_method(method)
  end

  def slow_waiting
    sleep 5
  end

  def slow_waiting_method(method)
    slow_waiting; method; slow_waiting
  end

  def scroll_page
    smooth_scrolling_down
    scroll_page_to(:up)
  end

  def smooth_scrolling_down
    puts 'Smooth scrolling down'

    slow_waiting_method(
      0.step(2_000, 20) do |v|
        page.execute_script "window.scrollTo(0, #{v})"
        sleep 0.0001
      end
    )
  end

  def scroll_page_to(action)
    puts "Scroll to #{action.to_s} page"

    value = { up: -10_000, down: 10_000 }[action]

    slow_waiting_method(
      page.execute_script "window.scrollTo(0, #{value})"
    )
  end

  def scroll_to_element(element, position = :top)
    scroll_to(element, align: position)
  end

  def blocked_action_on_page?
    if page.has_text?('Повторите попытку позже')
      abort('Превышены лимиты, получена ошибка -> Повторите попытку позже')
    end
  end
end
