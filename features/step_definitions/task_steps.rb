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

Then /^I should see the task "([^"]*)" followed by the task "([^"]*)"$/ do |task1, task2|
  page.should have_css("li:contains('#{task1}') ~ li:contains('#{task2}')")
end

Then /^I should see the task "([^"]*)" with a due date of "([^"]*)"$/ do |task, due_date|
  page.should have_css("li:contains('#{task}') > span.date:contains('#{due_date}')")
end

Then /^I should not see the task "([^"]*)"$/ do |task|
  page.should_not have_css("li:contains('#{task}')")
end

When /^I click on the task "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  page.evaluate_script %{$("#list_#{task.list.id} li:contains('#{title}')").trigger('click');}
  sleep 0.5
end
