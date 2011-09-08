When /^I fill in "([^"]*)"'s task title with "([^"]*)"$/ do |title, task|
  list = List.find_by_title!(title)
  within "#list_#{list.id}" do
    fill_in "new_task_title_#{list.id}", :with => task
  end
end

When /^I submit "([^"]*)"'s task form$/ do |title|
  list = List.find_by_title!(title)
  page.execute_script("$('#new_task_#{list.id}').trigger('submit')")
  sleep 1
end

Then /^I should see the task "([^"]*)"$/ do |task_title|
  page.should have_css(".list:not(.upcoming) li:contains('#{task_title}')")
end

Then /^I should see the upcoming task "([^"]*)"$/ do |task_title|
  page.should have_css("#upcoming_tasks li:contains('#{task_title}')")
end

Then /^I should see the task "([^"]*)" followed by the task "([^"]*)"$/ do |task1, task2|
  page.should have_css("li:contains('#{task1}') ~ li:contains('#{task2}')")
end

Then /^I should see the task "([^"]*)" with a due date of "([^"]*)"$/ do |task_title, due_date|
  task = Task.find_by_title!(task_title)
  page.should have_css("#task_#{task.id} span.date:contains('#{due_date}')")
end

Then /^I should not see the task "([^"]*)"$/ do |task|
  page.should_not have_css("li:contains('#{task}')")
end

When /^I click the task "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  find("#list_#{task.list.id} li:contains('#{task.display_title}') span.task_title").click
end


When /^I double click the task "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  page.evaluate_script %{ toggle_completed($("#task_#{task.id}"), '#{task.id}') }
end

When /^I fill in the title for "([^"]*)" with "([^"]*)"$/ do |title, new_title|
  task = Task.find_by_title!(title)
  within "#task_#{task.id}" do
    fill_in 'task_title', :with => new_title
  end
end

When /^I submit the title form for "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  page.execute_script %{ $("#task_#{task.id} form").trigger('submit') }
  sleep 2
end

When /^I blur the title form for "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  page.execute_script %{ $('#task_#{task.id} form input').trigger('blur') }
  sleep 2
end

When /^I drag the task "([^"]*)" over "([^"]*)"$/ do |task_title_1, task_title_2|
  task_1 = Task.find_by_title!(task_title_1)
  task_2 = Task.find_by_title!(task_title_2)
  page.execute_script %{ update_task_position($('#task_#{task_2.id}'), $('#task_#{task_2.id}').index() + 1) }
  sleep 2
end

Then /^I should see the task "([^"]*)" before "([^"]*)"$/ do |task_title_1, task_title_2|
  task_1 = Task.find_by_title!(task_title_1)
  task_2 = Task.find_by_title!(task_title_2)
  page.should have_css("#task_#{task_1.id} ~ #task_#{task_2.id}")
end

When /^I fill in "([^"]*)"'s task title with (\d+) "([^"]*)"$/ do |title, count, value|
  list = List.find_by_title!(title)
  within "#list_#{list.id}" do
    fill_in "new_task_title_#{list.id}", :with => value * count.to_i
  end
end

Then /^I should see the task with (\d+) "([^"]*)"$/ do |count, value|
  page.should have_css(".list:not(.upcoming) li:contains('#{value * count.to_i}')")
end

Then /^I should see the upcoming task "([^"]*)" before "([^"]*)"$/ do |task_title_1, task_title_2|
  task_1 = Task.find_by_title!(task_title_1)
  task_2 = Task.find_by_title!(task_title_2)
  page.should have_css("#upcoming_task_#{task_1.id} ~ #upcoming_task_#{task_2.id}")
end

Then /^the title being edited should be "([^"]*)"$/ do |title|
end

Given /^I complete "([^"]*)" on "([^"]*)"$/ do |title, date_str|
  date = Date.parse(date_str)
  task = Task.find_by_title!(title)
  Timecop.freeze(date) do
    task.update_attributes(:completed => true)
  end
end
