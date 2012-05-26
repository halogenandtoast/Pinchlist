require 'spec_helper'

describe User do
  it { should have_many(:list_proxies) }
  it { should have_many(:lists).through(:list_proxies) }
  it { should have_many(:owned_lists) }
end

describe User, '#proxy_for' do
  subject { create(:user) }
  let(:list) { create(:list, :user => subject) }
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

describe User, "#tasks" do
  subject { create(:user) }
  let!(:list) { create(:list, :user => subject) }
  let!(:tasks) { 3.times.map { create(:task, :list => list) } }
  before do
    3.times { create(:task) }
  end
  it "returns the correct tasks" do
    subject.tasks.to_a =~ tasks
  end
end
