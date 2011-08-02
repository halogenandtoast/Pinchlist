require 'spec_helper'

describe Share, '#valid' do
  let(:list) { Factory(:list) }
  subject { Share.new(:list_id => list.id) }
  it { should validate_format_of(:email).with('foo@example.com') }
  it { should validate_format_of(:email).not_with('fooexample.com').with_message("Invalid email address") }
  it { should validate_format_of(:email).not_with('foo@examplecom').with_message("Invalid email address") }
end

describe Share, 'invalid' do
  let(:email) { "foo" }
  let(:list) { stub('list', :proxies => true) }
  subject { Share.new(:list_id => 2, :email => email) }
  before do
    List.stubs(:find).with(2).returns(list)
    MemberMailer.stubs(:share_list_email => false)
  end
  it "does not send an email" do
    subject.save
    MemberMailer.should have_received(:share_list_email).never
  end

  it "does not create a proxy" do
    subject.save
    list.should have_received(:proxies).never
  end
end

describe Share, 'create' do
  let(:email) { 'foo@example.com' }
  let(:mail) { stub('mail', :deliver => true) }
  let(:user) { stub('user', :new_record? => true, :invitation_to_share => mail) }
  let(:proxies) { stub('proxies', :create => true) }
  let(:list) { stub('list', :proxies => proxies, :user => false) }

  before do
    MemberMailer.stubs(:share_list_email => mail)
    User.stubs(:find_or_create_by_email).with(email).returns(user)
    List.stubs(:find).with(2).returns(list)
  end

  it "shares with the user" do
    Share.new(:list_id => 2, :email => email).save
    user.should have_received(:invitation_to_share).with(list)
  end

  it "creates a proxy" do
    Share.new(:list_id => 2, :email => 'foo@example.com').save
    proxies.should have_received(:create).with(has_entries(:user => user))
  end
end

