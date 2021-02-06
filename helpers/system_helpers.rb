# frozen_string_literal: true

require_relative '../spec_helper'
require 'yaml'

SPEED_OF_USER_MOUSE = rand(0.5..0.8)

module Helpers
  include Capybara::DSL

  def mouse_move
    Mouse.move_to [
      rand(100..800),
      rand(100..800)
    ], SPEED_OF_USER_MOUSE
  end

  def scroll_down
    page.execute_script "window.scrollTo(0, #{rand(100..800)})"; sleep 3
  end

  def scroll_up
    page.execute_script 'window.scrollTo(0, -10000)'; sleep 3
  end

  def scroll_to_element(element, position = :top)
    scroll_to(element, align: position)
  end

  def move_scroll_and_return_top
    count_scrolls = rand(1..5)
    count_scrolls.times { scroll_down; mouse_move }; scroll_up
  end

  def search_and_select_value(name)
    puts "Search -> #{name}"

    fill_in('Поиск', with: name); sleep 3
    all(:xpath, '//span[contains(@aria-label, "Хэштег")]').first.click

    WaitUtil.wait_for_condition(
      "Tag #{name} found on page",
      timeout_sec: 10,
      delay_sec: 3
    ) { find(:xpath, "//h1[contains(., '#{name}')]") }
  end

  def visit_home_page
    visit 'https://www.instagram.com'
  end

  def visit_to(link)
    puts "Visit to #{link}"
    visit link
  end

  def ordinary_behaviour_people(method)
    sleep 3
    move_scroll_and_return_top
    method
    sleep 3
  end

  def blocked_action_on_page?
    if page.has_text?('Повторите попытку позже')
      abort('Превышены лимиты, получена ошибка -> Повторите попытку позже')
    end
  end
end
