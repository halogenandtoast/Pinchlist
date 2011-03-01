When /^I click the share icon$/ do
  locate("a.share_link").click
end

When /^I submit the share form$/ do
  page.execute_script("$('#share_form').trigger('submit')")
end

When /^I fill in share email with "([^"]*)"$/ do |email|
  fill_in("share_email", :with => email)
end
