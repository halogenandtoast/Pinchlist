require 'spec_helper'

describe Share, '#valid' do
  let(:list) { Factory(:list) }
  subject { Share.new(:list_id => list.id) }
  it { should validate_format_of(:email).with('foo@example.com') }
  it { should validate_format_of(:email).not_with('fooexample.com').with_message("Invalid email address") }
  it { should validate_format_of(:email).not_with('foo@examplecom').with_message("Invalid email address") }
end


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
    Share.new(:list_id => 2, :email => email).save
    User.should have_received(:share_by_email).with(email, list)
  end

  it "creates a proxy" do
    Share.new(:list_id => 2, :email => 'foo@example.com').save
    proxies.should have_received(:create).with(has_entries(:user => user))
  end
end

