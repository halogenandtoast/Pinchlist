When /^I fill in the list title with "([^"]*)"$/ do |title|
  fill_in 'list_title', :with => title
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
  page.should have_css("#list_#{list.id} li.completed:contains('#{title}')")
end

Then /^I should see the following "([^"]*)" tasks in order:$/ do |title, table|
  css_matcher = table.raw.flatten.map { |title| "li:contains('#{title}')" }.join(' ~ ')
  list = List.find_by_title!(title)
  within "#list_#{list.id}" do
    page.should have_css(css_matcher)
  end
end

When /^I click the delete link for "([^"]*)"$/ do |title|
  list = List.find_by_title!(title)
  find("#list_#{list.id} a.delete").click
end

Then /^I should not see the list "([^"]*)"$/ do |title|
  page.should_not have_css(".list:contains('#{title}')")
end

When /^I double click the list title "([^"]*)"$/ do |title|
  list = List.find_by_title!(title)
  page.evaluate_script %{ list_edit($('#list_#{list.id} .list_title h3')) }
end

When /^I fill in the list title for "([^"]*)" with "([^"]*)"$/ do |title, value|
  list = List.find_by_title!(title)
  within "#list_#{list.id}" do
    fill_in "list_title", :with => value
  end
end

When /^I submit the list title form for "([^"]*)"$/ do |title|
  list = List.find_by_title!(title)
  page.evaluate_script %{ $('#list_#{list.id} .list_title form').trigger('submit') }
end

When /^I drag the list "([^"]*)" over "([^"]*)"$/ do |list_title_1, list_title_2|
  list_1 = List.find_by_title!(list_title_1)
  list_2 = List.find_by_title!(list_title_2)
  page.execute_script %{ update_list_position($('#list_#{list_2.id}'), $('.list:not(.upcoming)').index('#list_#{list_2.id}')) }
  sleep 2
end

Then /^I should see the list "([^"]*)" before "([^"]*)"$/ do |list_title_1, list_title_2|
  list_1 = List.find_by_title!(list_title_1)
  list_2 = List.find_by_title!(list_title_2)
  page.should have_css("#list_#{list_1.id} ~ #list_#{list_2.id}")
end
