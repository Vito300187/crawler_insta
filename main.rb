# frozen_string_literal: true

require_relative 'spec_helper'
RECENT_POSTS = 3

feature 'Test' do
  let(:home_page) { Pages::HomePage.new }
  let(:tag_page) { Pages::TagPage.new }
  let(:post_page) { Pages::PostPage.new }

  scenario 'Scrolling Insta' do
    home_page.sigh_in
    user_post_links = tag_page.mark_recent_posts(TAG)
    user_post_links.each do |user_post_link|
      tag_page.visit_to(user_post_link)
      post_page.subscribe_and_move_to_user_page
      post_page.like_on_last_photos
    end

    info = "Время окончания скрипта -> #{Time.now.strftime('%H:%M')};\
Кол-во подписок -> #{post_page.subscribe_users};\
Кол-во лайков -> #{post_page.count_likes}"

    write_report('report.txt', info)
  end
end
