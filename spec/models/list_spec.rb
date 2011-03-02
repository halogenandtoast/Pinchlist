require 'spec_helper'

describe List do
  it { should belong_to :user }
  it { should have_many(:tasks).dependent(:destroy) }
  it { should have_many(:proxies) }
  it { should have_many(:users).through(:proxies) }

  context 'when saved' do
    it 'creates a list proxy for the user' do
      user = Factory(:user)
      list = Factory(:list, :user => user)
      list.proxies.first.user.should == user
    end
  end

  describe 'updated' do
    context 'with empty title' do
      subject { Factory(:list) }
      it 'should set the title to the id' do
        subject.title = ""
        subject.title.should == "List #{subject.id}"
      end
    end
  end
end

describe List, '#check_for_proxies' do
  subject { Factory(:list) }
  context 'with more proxies' do
    before do
      subject.stubs(:proxies).returns([1])
      subject.stubs(:destroy)
    end
    it "does not destroy the list" do
      subject.check_for_proxies
      subject.should have_received(:destroy).never
    end
  end
  context 'without more proxies' do
    before do
      subject.stubs(:proxies).returns([])
      subject.stubs(:destroy)
    end
    it "destroys the list" do
      subject.check_for_proxies
      subject.should have_received(:destroy)
    end
  end
end

describe List, '#shared_users' do
  let(:user) { Factory(:user) }
  let(:expected_users)  { 3.times.map { Factory(:user) } }
  subject { Factory(:list, :user => user) }
  before do
    expected_users.each { |user| Factory(:list_proxy, :list => subject, :user => user) }
  end
  it "contains the correct users" do
    subject.shared_users.to_a.should =~ expected_users
  end
end
