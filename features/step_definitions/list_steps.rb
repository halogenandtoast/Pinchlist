When /^I fill in the list title with "([^"]*)"$/ do |title|
  fill_in 'list_title', :with => title
end

Then /^I should see the list "([^"]*)"$/ do |title|
  page.should have_content(title)
end

When /^I submit the new list form$/ do
  page.execute_script("$('new_list').submit()")
end
