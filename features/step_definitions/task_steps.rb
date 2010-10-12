When /^I fill in "([^"]*)"'s task title with "([^"]*)"$/ do |title, task|
  list = List.find_by_title!(title)
  within "#list_#{list.id}" do
    fill_in "task_title", :with => task
  end
end

When /^I submit "([^"]*)"'s task form$/ do |title|
  list = List.find_by_title!(title)
  page.execute_script("$('#new_task_#{list.id}').submit()")
end

Then /^I should see the task "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
