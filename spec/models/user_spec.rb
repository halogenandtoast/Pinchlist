require 'spec_helper'

describe User do
  it { should have_many(:tasks).through(:lists) }
  it { should have_many(:list_proxies) }
  it { should have_many(:lists).through(:list_proxies) }
end

describe User, '#proxy_for' do
  subject { Factory(:user) }
  let(:list) { Factory(:list, :user => subject) }
  let(:proxy) { mock("proxy") }
  let(:list_proxies) { mock("list proxies") }

  before do
    list_proxies.stubs(:find_by_list_id).with(list.id).returns(proxy)
    subject.stubs(:list_proxies).returns(list_proxies)
  end

  it "returns the correct proxy when given a list object" do
    subject.proxy_for(list).should == proxy
  end

  it "returns the correct proxy when given a list id" do
    subject.proxy_for(list.id).should == proxy
  end
end

