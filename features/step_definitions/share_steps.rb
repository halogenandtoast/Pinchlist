When /^I click the share icon$/ do
  locate("a.share_link").click
end

When /^I submit the share form$/ do
  page.execute_script("$('.share_form').trigger('submit')")
  sleep 5
end

When /^I fill in share email with "([^"]*)"$/ do |email|
  fill_in("share[email]", :with => email)
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
  locate('input[name="share[email]"]').value.should == ''
end

When /^"([^"]*)" should see the invitation link in the email body$/ do |email|
  user = User.find_by_email(email)
  url = accept_user_invitation_url(:invitation_token => user.invitation_token, :host => "example.com")
  Then %{they should see "#{url}" in the email body}
end
