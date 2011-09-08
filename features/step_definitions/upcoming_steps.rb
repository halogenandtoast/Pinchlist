Then /^I should see the following upcoming tasks in order:$/ do |table|
  css_matcher = table.raw.flatten.map { |title| "li:contains('#{title}')" }.join(' ~ ')
  within '#upcoming_tasks' do
    page.should have_css(css_matcher)
  end
end

Then /^I should see the completed upcoming task "([^"]*)"$/ do |title|
  page.should have_css("#upcoming_tasks li.completed:contains('#{title}')")
end

When /^I click the upcoming task "([^"]*)"$/ do |title|
  find("#upcoming_tasks li:contains('#{title}') span.task_title").click
end

When /^I double click the upcoming task "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  page.evaluate_script %{ toggle_completed($("#upcoming_tasks li:contains('#{title}')"), '#{task.id}', "upcoming") }
  # page.evaluate_script %{ task_edit($("#upcoming_tasks li:contains('#{title}')"), '#{task.id}', "upcoming") }
end

When /^I fill in the upcoming title for "([^"]*)" with "([^"]*)"$/ do |title, new_title|
  task = Task.find_by_title!(title)
  within "#upcoming_task_#{task.id}" do
    fill_in 'task_title', :with => new_title
  end
end

When /^I submit the upcoming title form for "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  page.execute_script %{ $('#upcoming_task_#{task.id} form').trigger('submit') }
  sleep 2
end

Then /^the upcoming title field for "([^"]*)" should contain "([^"]*)"$/ do |original_title, expected_title|
  task = Task.find_by_title!(original_title)
  find("#upcoming_task_#{task.id} form input").value.should == expected_title
end

Then /^I should see the upcoming task "([^"]*)" with a due date of "([^"]*)"$/ do |title, due_date|
  within '#upcoming_tasks' do
    page.should have_css("li span.date:contains('#{due_date}')")
    page.should have_css("li span.task_title:contains('#{title}')")
  end
end

Then /^I should not see the upcoming task "([^"]*)"$/ do |title|
  within '#upcoming_tasks' do
    page.should have_no_css("li span.task_title:contains('#{title}')")
  end
end

Then /^I do not see the upcoming tasks list$/ do
  page.should_not have_css("#upcoming_tasks")
end

Then /^I see the upcoming task "([^"]*)" has a due date color of "([^"]*)"$/ do |title, color|
  task = Task.find_by_title!(title)
  within "#upcoming_task_#{task.id}" do
    page.should have_css("span.date[style*='color: ##{color}']")
  end
end
