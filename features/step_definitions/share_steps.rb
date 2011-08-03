When /^I click the share icon$/ do
  find("a.share_link").click
end

When /^I should not see the sharing icon for "([^"]+)"$/ do |title|
  list = List.find_by_title(title)
  page.should have_no_css("#list_#{list.id} a.share_link")
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

Then /^I should not see that the list is shared with "([^"]*)"$/ do |email|
  within '.shared_users' do
    page.should have_no_content(email)
  end
end

Then /^I should see that the list is shared$/ do
  first(".share_link").visible?.should be_true
end

Then /^I should see that the list is not shared$/ do
  first(".share_link").visible?.should be_false
end

Then /^the share email field is blank$/ do
  find('input[name="share[email]"]').value.should == ''
end

When /^"([^"]*)" should see the invitation link in the email body$/ do |email|
  user = User.find_by_email(email)
  url = accept_user_invitation_url(:invitation_token => user.invitation_token, :host => "example.com")
  Then %{they should see "#{url}" in the email body}
end

When /^I remove "([^"]*)" from the list$/ do |arg1|
  page.execute_script("$('.shared_users a.remove').trigger('click')")
  sleep 1
end
