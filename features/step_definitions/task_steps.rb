When /^I fill in "([^"]*)"'s task title with "([^"]*)"$/ do |title, task|
  list = List.find_by_title!(title)
  within "#list_#{list.id}" do
    fill_in "new_task_title_#{list.id}", :with => task
  end
end

When /^I submit "([^"]*)"'s task form$/ do |title|
  list = List.find_by_title!(title)
  page.execute_script("$('#new_task_#{list.id}').trigger('submit')")
end

Then /^I should see the task "([^"]*)"$/ do |task_title|
  task = Task.find_by_title!(task_title)
  page.should have_css("#list_#{task.list_id} li:contains('#{task_title}')")
end

Then /^I should see the upcoming task "([^"]*)"$/ do |task_title|
  page.should have_css("#upcoming_tasks li:contains('#{task_title}')")
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
  find("#list_#{task.list.id} li:contains('#{title}')").click
end
