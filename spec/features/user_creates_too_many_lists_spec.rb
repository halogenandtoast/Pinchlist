require 'spec_helper'

feature 'user who has not paid creates too many lists' do
  scenario 'sees an error message', js: true do
    sign_in_user_with_lists(3)
    visit dashboard_path
    create_list "Wombats"
    expect(page).to have_content("Upgrade to create more lists.")
  end

  def sign_in_user_with_lists(count)
    user = create(:user)
    count.times { create(:list, user: user) }
    login_as(user)
  end

  def create_list title
    find("#list_title").set("Wombats")
    find('#new_list').trigger("submit")
  end
end
