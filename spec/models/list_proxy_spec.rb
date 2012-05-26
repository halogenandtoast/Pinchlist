require 'spec_helper'

describe ListProxy do
  it { should belong_to :user }
  it { should belong_to :list }
  it { should have_many(:tasks).through(:list) }

  context 'when saved' do
    it 'receives a color' do
      list_proxy = create(:list_proxy)
      list_proxy.color.should_not be_nil
    end
  end

  context 'the first list proxy' do
    it 'should start at order 1' do
      list_proxy = create(:list_proxy)
      list_proxy.position.should == 1
    end
  end

  context 'additional list proxies' do
    it 'should start at the correct order' do
      user = create(:user)
      first, second, third = [*1..3].map{|i| create(:list_proxy, user: user) }
      first.position.should == 1
      second.position.should == 2
      third.position.should == 3
    end
  end

  context 'when destroyed' do
    subject { create(:list_proxy) }
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
  let!(:list) { create(:list) }
  subject { create(:list_proxy, :list => list) }
  before { list.stubs(:shared?) }
  it "delegates to list" do
    subject.shared?
    list.should have_received(:shared?)
  end
end

describe ListProxy, "#shared_users" do
  let(:list) { create(:list) }
  subject { create(:list_proxy, list: list, user: list.user) }
  let!(:other_proxy) { create(:list_proxy, list: subject.list) }
  it "returns a list of users from the list" do
    subject.shared_users.should == [other_proxy.user]
  end
end

describe ListProxy, "#title" do
  let!(:list) { create(:list, :title => "Foo bar") }
  subject { create(:list_proxy, :list => list) }
  its(:title) { should == list.title }
end

describe ListProxy, ".by_position" do
  let!(:user) { create(:user) }

  let!(:second) { create(:list, :user => user).proxies.first }
  let!(:third) { create(:list, :user => user).proxies.first }
  let!(:first) { create(:list, :user => user).proxies.first }

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
  let(:user) { create(:user_with_list) }
  let(:other_user) { create(:user) }
  let(:list) { list_proxy.list }
  let(:other_list_proxy) { create(:list_proxy, user: other_user, list: list) }
  let(:list_proxy) { user.list_proxies.first }

  it "returns true for the owner" do
    list_proxy.owned_by?(user).should be_true
    other_list_proxy.owned_by?(user).should be_true
  end

  it "returns false for the other user" do
    list_proxy.owned_by?(other_user).should be_false
    other_list_proxy.owned_by?(other_user).should be_false
  end
end
