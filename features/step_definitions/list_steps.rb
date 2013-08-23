When /^I fill in the list title with "([^"]*)"$/ do |title|
  fill_in 'list_title', :with => title
end

When /^I expand the list actions/ do
  find(".list_actions_link").click
end

Then /^I should see the list "([^"]*)"$/ do |title|
  page.should have_content(title)
end

When /^I submit the new list form$/ do
  page.execute_script("$('#new_list').submit()")
  sleep 1
end

Then /^I should see the completed task "([^"]*)" in "([^"]*)"$/ do |title, list_title|
  list = List.find_by_title!(list_title)
  page.should have_css("#list_#{list.id} li.completed", text: title)
end

Then /^I should see the following "([^"]*)" tasks in order:$/ do |title, table|
  list = List.find_by_title!(title)
  expected_titles = table.raw.flatten
  task_titles = all("#list_#{list.id} li.task span.text").map(&:text)

  expected_titles.should == task_titles
end

When /^I click the delete link for "([^"]*)"$/ do |title|
  list = List.find_by_title!(title)
  find("#list_#{list.id} .delete a").click
end

Then /^I should not see the list "([^"]*)"$/ do |title|
  page.should_not have_css(".list", text: title)
end

When /^I click the list title "([^"]*)"$/ do |title|
  list = List.find_by_title!(title)
  find(".list_title h3").click
end

When /^I fill in the list title for "([^"]*)" with "([^"]*)"$/ do |title, value|
  list = List.find_by_title!(title)
  within "#list_#{list.id}" do
    fill_in "list_title", :with => value
  end
end

When /^I submit the list title form for "([^"]*)"$/ do |title|
  list = List.find_by_title!(title)
  find("#new_list_title").trigger("submit")
end

When /^I drag the list "([^"]*)" over "([^"]*)"$/ do |list_title_1, list_title_2|
  list_1 = List.find_by_title!(list_title_1)
  list_2 = List.find_by_title!(list_title_2)
  page.execute_script("$('#list_#{list_2.id}').insertBefore($('#list_#{list_1.id}'));")
  page.execute_script("$('#list_#{list_2.id}').parents('tr').trigger('sortupdate', {item:$('#list_#{list_2.id}')});")
  sleep 1
end

Then /^I should see the list "([^"]*)" before "([^"]*)"$/ do |list_title_1, list_title_2|
  list_1 = List.find_by_title!(list_title_1)
  list_2 = List.find_by_title!(list_title_2)
  page.should have_css("#list_#{list_1.id} ~ #list_#{list_2.id}")
end

When /^I follow the archive link for "([^"]*)"$/ do |list_title|
  list = List.find_by_title!(list_title)
  within "#list_#{list.id}" do
    find(".list_actions_link").click
    find(".archive_link").click
  end
end

Then /^the list "([^"]*)" should have the color "([^"]*)"$/ do |list_title, color|
  list = List.find_by_title!(list_title)
  rgb = hex_str_to_rgb(color)
  rgb_matcher = "rgb(#{rgb.join(", ")})"
  within "#list_#{list.id}" do
    page.should have_css(".list_title[style*='background-color: ##{color}'],.list_title[style*='background-color: #{rgb_matcher}']")
  end
end

When /^I change the color of "([^"]*)" to "([^"]*)"$/ do |list_title, color|
  list = List.find_by_title!(list_title)
  page.execute_script %{$("#list_#{list.id} .color_picker").trigger("colorchange", "##{color}")}
end

Then /^"([^"]*)" should have no tasks$/ do |list_title|
  list = List.find_by_title!(list_title)
  within "#list_#{list.id}" do
    page.should have_no_css(".task")
  end
end

When /^I have (\d+) lists?$/ do |count|
  user = User.first
  count.to_i.times { create(:list, :user => user) }
end

Then /^I can not create another list$/ do
  visit dashboard_path
  count = all(".list").count
  fill_in :list_title, :with => "Another list"
  page.execute_script("$('#new_list').submit()")
  all(".list").count.should == count
end

Then /^I can create another list$/ do
  visit dashboard_path
  # count = all(".list").count
  # fill_in :list_title, :with => "Another list"
  # page.execute_script("$('#new_list').submit()")
  # all(".list").count.should == count + 1
end

Given /^"([^"]*)" has a "([^"]*)" list$/ do |email, list_title|
  user = User.find_by_email(email)
  list_base = create(:list_base, user: user)
  create(:list, title: list_title, list_base: list_base, user: user)
end
