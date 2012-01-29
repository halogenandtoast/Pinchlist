When /^I upgrade my account$/ do
  visit edit_account_path
  fill_in :card_number, with: "4242424242424242"
  fill_in :card_cid, with: "123"
  fill_in :card_exp, with: 1.month.from_now.strftime("%m/%Y")
  click_button "Submit"
end
