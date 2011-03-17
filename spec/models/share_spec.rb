require 'spec_helper'

describe Share, 'create' do
  let(:email) { 'foo@example.com' }
  let(:user) { stub('user', :new_record? => true, :invite_with_share! => true) }
  let(:proxies) { stub('proxies', :create => true) }
  let(:list) { stub('list', :proxies => proxies) }

  before do
    User.stubs(:share_by_email).with(email, list).returns(user)
    List.stubs(:find).with(2).returns(list)
  end

  it "shares with the user" do
    Share.create(:list_id => 2, :email => email)
    User.should have_received(:share_by_email).with(email, list)
  end

  it "creates a proxy" do
    Share.create(:list_id => 2, :email => 'foo@example.com')
    proxies.should have_received(:create).with(has_entries(:user => user))
  end
end

