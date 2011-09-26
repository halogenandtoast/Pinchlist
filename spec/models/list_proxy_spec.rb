require 'spec_helper'

describe ListProxy do
  it { should belong_to :user }
  it { should belong_to :list }
  it { should have_many(:tasks).through(:list) }

  context 'when saved' do
    it 'receives a color' do
      list_proxy = Factory(:list_proxy)
      list_proxy.color.should_not be_nil
    end
  end

  context 'the first list proxy' do
    it 'should start at order 1' do
      list_proxy = Factory(:list_proxy)
      list_proxy.position.should == 1
    end
  end

  context 'additional list proxies' do
    it 'should start at the correct order' do
      user = Factory(:user)
      first, second, third = [*1..3].map{|i| Factory(:list_proxy, :user => user) }
      first.position.should == 1
      second.position.should == 2
      third.position.should == 3
    end
  end

  context 'when destroyed' do
    subject { Factory(:list_proxy) }
    let!(:list) { subject.list }
    before do
      list.stubs(:check_for_proxies)
    end

    it 'notifies the list' do
      subject.destroy
      list.should have_received(:check_for_proxies)
    end
  end
end

describe ListProxy, "#shared?" do
  let!(:list) { Factory(:list) }
  subject { Factory(:list_proxy, :list => list) }
  before { list.stubs(:shared?) }
  it "delegates to list" do
    subject.shared?
    list.should have_received(:shared?)
  end
end

describe ListProxy, "#shared_users" do
  let(:list) { Factory(:list) }
  subject { Factory(:additional_list_proxy, :list => list, :user => list.user) }
  let!(:other_proxy) { Factory(:additional_list_proxy, :list => subject.list) }
  it "returns a list of users from the list" do
    subject.shared_users.should == [other_proxy.user]
  end
end

describe ListProxy, "#title" do
  let!(:list) { Factory(:list, :title => "Foo bar") }
  subject { Factory(:list_proxy, :list => list) }
  its(:title) { should == list.title }
end

describe ListProxy, ".by_position" do
  let!(:user) { Factory(:user) }

  let!(:second) { Factory(:list, :user => user).proxies.first }
  let!(:third) { Factory(:list, :user => user).proxies.first }
  let!(:first) { Factory(:list, :user => user).proxies.first }

  before do
    first.update_attributes(:new_position => 1)
    second.update_attributes(:new_position => 2)
  end

  it "returns them in the correct position" do
    [first,second,third].map(&:reload)
    ListProxy.by_position.should == [first, second, third]
  end
end

describe ListProxy, ".owned_by?" do
  subject { Factory(:list_proxy) }
  let!(:user) { subject.user }
  let!(:other_user) { Factory(:user) }
  let!(:other_list_proxy) { Factory(:additional_list_proxy, :user => other_user, :list => subject.list) }

  it "returns true for the owner" do
    subject.owned_by?(user).should be_true
    other_list_proxy.owned_by?(user).should be_true
  end
  it "returns false for the owner" do
    subject.owned_by?(other_user).should be_false
    other_list_proxy.owned_by?(other_user).should be_false
  end
end
