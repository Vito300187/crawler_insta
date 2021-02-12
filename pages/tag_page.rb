# frozen_string_literal: true

require_relative '../helpers/system_helpers'

module Pages
  class TagPage
    include Capybara::DSL
    include Helpers

    def initialize
      @best_publications = '//h2[contains(., "Лучшие публикации")]'
      @close_modal_window = '//h1/parent::*//button'
      @new_publications = '//h2[contains(., "Сначала новые")]'
      @posts_list_links = '//article//div[contains(@style, "flex-direction")]//a'
    end

    def publications(action)
      find(
        :xpath,
        {
          new: @new_publications,
          best: @best_publications
        }[action]
      )
    end

    def posts_list_link
      all(:xpath, @posts_list_links).map { |link| link['href'] }
    end

    def select_multiple_posts(count)
      puts "Selected #{count} posts"
      posts_list_link.sample(count)
    end

    def close_modal_window_who_liked
      if page.has_xpath?(@close_modal_window)
        puts 'Closed modal window "Нравится"'
        find(:xpath, @close_modal_window).click
      end
    end

    def mark_recent_posts(tag, action = :new)
      [
        search_and_select_value(tag),
        scroll_to_element(publications(action))
      ].each { |act| ordinary_user_behaviour(act) }

      posts = select_multiple_posts(RECENT_POSTS)
      puts "Get 3 posts #{posts}"; posts
    end
  end
end
