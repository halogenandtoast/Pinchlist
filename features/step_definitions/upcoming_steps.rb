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
  find("#upcoming_tasks li:contains('#{title}') span.text").click
end

When /^I check the upcoming task "([^"]*)"$/ do |title|
  task = Task.find_by_title!(title)
  find("#upcoming_task_#{task.id} .checkbox").click
end

When /^I fill in the upcoming title for "([^"]*)" with "([^"]*)"$/ do |title, new_title|
  page.execute_script %{ $("#task_title").val('#{new_title}') }
end

When /^I submit the upcoming title form for "([^"]*)"$/ do |title|
  find("#edit_task").trigger("submit")
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
  page.find("#upcoming_tasks").visible?.should be_false
end

Then /^I see the upcoming task "([^"]*)" has a due date color of "([^"]*)"$/ do |title, color|
  task = Task.find_by_title!(title)
  rgb = hex_str_to_rgb(color)
  rgb_matcher = "rgb(#{rgb.join(", ")})"
  within "#upcoming_task_#{task.id}" do
    page.should have_css("span.date[style*='color: ##{color}'],span.date[style*='color: #{rgb_matcher}']")
  end
end
