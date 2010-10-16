Then /^I should see the following upcoming tasks in order:$/ do |table|
  css_matcher = table.raw.flatten.map { |title| "li:contains('#{title}')" }.join(' ~ ')
  within '#upcoming_tasks' do
    page.should have_css(css_matcher)
  end
end
