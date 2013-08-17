require 'spec_helper'

feature 'make a list public' do
  scenario 'confirm', js: true do
    list = list_on_page
    list.make_public(confirm: true)
    expect(page.current_path).to eq(list.public_path)
  end

  scenario 'do not confirm', js: true do
    list = list_on_page
    list.make_public(confirm: false)
    expect(page.current_path).to eq(dashboard_path)
  end

  scenario 'click lock', js: true do
    list = list_on_page
    list.click_lock
    expect(list).to be_unlocked_and_public
  end

  scenario 'click lock when public', js: true do
    list = list_on_page(public: true)
    list.click_lock
    expect(list).to be_locked_and_private
  end

  def list_on_page(options = {})
    ListOnPage.new(options).tap do |list|
      login_as(list.user)
      visit dashboard_path
    end
  end

  class ListOnPage
    include Capybara::DSL
    include Rails.application.routes.url_helpers

    def initialize(options = {})
      @list = FactoryGirl.create(:list, options)
    end

    def user
      list.user
    end

    def click_lock
      find(".list_actions_link").click
      find(".public_link_toggle").click
    end

    def unlocked_and_public?
      page.has_css?(".public_link_toggle.unlocked") && is_public?
    end

    def locked_and_private?
      page.has_css?(".public_link_toggle.locked") && is_private?
    end

    def make_public(options = {})
      accept_js_confirms(options[:confirm])
      click_public_link

      if options[:confirm]
        wait_for_page_to_load
      end
    end

    def public_path
      public_list_path(list.public_token, slug: list.slug)
    end

    private
    attr_reader :list

    def wait_for_page_to_load
      find("td.public")
    end

    def accept_js_confirms(accept)
      if accept
        page.driver.accept_js_confirms!
      else
        page.driver.dismiss_js_confirms!
      end
    end

    def click_public_link
      find(".list_actions_link").click
      click_link "Public URL"
    end

    def is_private?
      !is_public?
    end

    def is_public?
      list.reload.public?
    end
  end
end
