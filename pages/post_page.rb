# frozen_string_literal: true

require_relative '../helpers/system_helpers'

module Pages
  class PostPage
    include Capybara::DSL
    include Helpers

    attr_accessor :count_likes, :subscribe_users

    def initialize
      @count_likes = 0
      @like_text = 'Нравится'
      @clear_heart = "//*[@aria-label='#{@like_text}' and @height='24']"
      @profile_user_link = '//header//span//a'
      @photo_list_link = '//div[contains(@style, "flex-direction")]//a'
      @photos_on_page = '//article//div[contains(@style, "flex-direction")]//a'
      @subscribe = 'Подписаться'
      @subscribes = 'Подписки'
      @subscribe_users = 0
      @subscription_completed = 'Subscription completed'
    end

    def profile_user_link
      find(:xpath, @profile_user_link)['href']
    end

    def profile_closed?
      page.has_text?('Это закрытый аккаунт')
    end

    def subscribed?
      page.has_xpath?("//button[contains(text(), '#{@subscribes}')]")
    end

    def subscribe
      click_button(@subscribe)
      puts @subscription_completed

      3.times do |second|
        sleep second
        next if subscribed?

        find(:xpath, @subscribe).click; sleep second
      end
    end

    def subscribe_action
      return 'Profile closed' if profile_closed?

      unless subscribed?
        subscribe
        self.subscribe_users += 1
      end

      blocked_action_on_page?
    end

    def subscribe_and_move_to_user_page
      [
        subscribe_action,
        visit_to(profile_user_link)
      ].each { |act| ordinary_user_behaviour(act) }
    end

    def last_recent_post_users
      all(:xpath, @photos_on_page).first(RECENT_POSTS).map { |h| h['href'] }
    end

    def like_on_last_photos
      puts "Get 3 photos #{last_recent_post_users}"
      last_recent_post_users.each do |link|
        visit_to(link)
        ordinary_user_behaviour(set_like)
      end
    end

    def liked?
      page.has_no_xpath?(@clear_heart)
    end

    def set_like
      if liked?
        puts 'like already added'
      else
        puts 'Like click'
        3.times do |second|
          sleep second
          next if liked?

          find(:xpath, @clear_heart).click; sleep second
        end

        self.count_likes += 1
      end

      blocked_action_on_page?
    end
  end
end
