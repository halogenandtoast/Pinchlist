Then /^I should see the following upcoming tasks in order:$/ do |table|
  css_matcher = table.raw.flatten.map { |title| "li:contains('#{title}')" }.join(' ~ ')
  within '#upcoming_tasks' do
    page.should have_css(css_matcher)
  end
end

Then /^I should see the completed upcoming task "([^"]*)"$/ do |title|
  page.should have_css("#upcoming_tasks li.completed:contains('#{title}')")
end

When /^I click on the upcoming task "([^"]*)"$/ do |title|
  find("#upcoming_tasks li:contains('#{title}')").click
end

When /^I double click the upcoming task "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  page.evaluate_script %{ task_edit($("#upcoming_tasks li:contains('#{title}')"), '#{task.id}') }
end

When /^I fill in the upcoming title for "([^"]*)" with "([^"]*)"$/ do |title, new_title|
  task = Task.find_by_title!(title)
  within "#upcoming_task_#{task.id}" do
    fill_in 'task_title', :with => new_title
  end
end

When /^I submit the upcoming title form for "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  find("#upcoming_task_#{task.id} form").trigger("submit")
end
