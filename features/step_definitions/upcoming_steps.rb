Then /^I should see the following upcoming tasks in order:$/ do |table|
  css_matcher = table.raw.flatten.map { |title| "li:contains('#{title}')" }.join(' ~ ')
  within '#upcoming_tasks' do
    page.should have_css(css_matcher)
  end
end

When /^I click on the upcoming task "([^"]*)"$/ do |title|
  page.evaluate_script %{$("#upcoming_tasks li:contains('#{title}')").trigger('click');}
  sleep 0.5
end

Then /^I should see the completed upcoming task "([^"]*)"$/ do |title|
  page.should have_css("#upcoming_tasks li.completed:contains('#{title}')")
end
