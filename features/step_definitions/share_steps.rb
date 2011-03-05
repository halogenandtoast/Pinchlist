When /^I click the share icon$/ do
  locate("a.share_link").click
end

When /^I submit the share form$/ do
  page.execute_script("$('#share_form').trigger('submit')")
  sleep 2
end

When /^I fill in share email with "([^"]*)"$/ do |email|
  fill_in("share_email", :with => email)
end

Then /^the list "([^"]*)" should be shared with "([^"]*)"$/ do |title, email|
  list = List.find_by_title!(title)
  user = User.find_by_email!(email)
  list.shared_users.should include(user)
end

Then /^I should see that the list is shared with "([^"]*)"$/ do |email|
  within '.shared_users' do
    page.should have_content(email)
  end
end
Then /^the share email field is blank$/ do
  locate('input[name="share_email"]').value.should == ''
end
