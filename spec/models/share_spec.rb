require 'spec_helper'

describe Share, 'initialize' do
  let(:user) { stub('user') }
  let(:list) { stub('list') }
  subject { Share.new(user, list) }
  its(:user) { should == user }
  its(:list) { should == list }
end

describe Share, 'create' do
  context 'with a current member' do
    let(:user) { stub('user', :new_record? => false) }
    let(:proxies) { stub('proxies', :create => true) }
    let(:mail) { stub('mail', :deliver => true) }
    let(:list) { stub('list', :proxies => proxies) }
    before do
      User.stubs(:find_or_create_by_email).with('foo@example.com').returns(user)
      List.stubs(:find).with(2).returns(list)
      MemberMailer.stubs(:share_list_email).returns(mail)
    end
    it "creates a new share" do
      share = Share.create(:list_id => 2, :email => 'foo@example.com')
      share.should be_a(Share)
    end
    it "emails the user" do
      Share.create(:list_id => 2, :email => 'foo@example.com')
      mail.should have_received(:deliver)
    end
    it "creates a proxy" do
      Share.create(:list_id => 2, :email => 'foo@example.com')
      proxies.should have_received(:create).with(has_entries(:user => user))
    end
  end

  context 'with a non-existant member' do
    let(:user) { stub('user', :new_record? => true, :invite_with_share! => true) }
    let(:proxies) { stub('proxies', :create => true) }
    let(:list) { stub('list', :proxies => proxies) }
    before do
      User.stubs(:find_or_create_by_email).with('foo@example.com').returns(user)
      List.stubs(:find).with(2).returns(list)
    end
    it "creates a new share" do
      share = Share.create(:list_id => 2, :email => 'foo@example.com')
      share.should be_a(Share)
    end
    it "emails the user" do
      share = Share.create(:list_id => 2, :email => 'foo@example.com')
      user.should have_received(:invite_with_share!).with(share)
    end
    it "creates a proxy" do
      Share.create(:list_id => 2, :email => 'foo@example.com')
      proxies.should have_received(:create).with(has_entries(:user => user))
    end

  end
end

