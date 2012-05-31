require 'spec_helper'

describe List do
  it { should belong_to :user }
  it { should belong_to :list_base }
  it { should have_many(:tasks).through(:list_base) }

  context 'when saved' do
    it 'receives a color' do
      list = create(:list)
      list.color.should_not be_nil
    end
  end

  context 'the first list proxy' do
    it 'should start at order 1' do
      list = create(:list)
      list.position.should == 1
    end
  end

  context 'additional list proxies' do
    it 'should start at the correct order' do
      user = create(:user)
      first, second, third = [*1..3].map{|i| create(:list, user: user) }
      first.position.should == 1
      second.position.should == 2
      third.position.should == 3
    end
  end

  context 'when destroyed' do
    subject { create(:list) }
    let!(:list_base) { subject.list_base }
    before do
      list_base.stubs(:check_for_proxies)
    end

    it 'notifies the list' do
      subject.destroy
      list_base.should have_received(:check_for_proxies)
    end
  end
end

describe List, "#shared?" do
  let!(:list_base) { create(:list_base) }
  subject { create(:list, list_base: list_base) }
  before { list_base.stubs(:shared?) }
  it "delegates to list" do
    subject.shared?
    list_base.should have_received(:shared?)
  end
end

describe List, "#shared_users" do
  let(:list_base) { create(:list_base) }
  subject { create(:list, list_base: list_base, user: list.user) }
  let!(:other_proxy) { create(:list, list_base: subject.list_base) }
  it "returns a list of users from the list" do
    subject.shared_users.should == [other_proxy.user]
  end
end

describe List, ".by_position" do
  let!(:user) { create(:user) }

  let!(:second) { create(:list, :user => user) }
  let!(:third) { create(:list, :user => user) }
  let!(:first) { create(:list, :user => user) }

  before do
    first.update_attributes(:new_position => 1)
    second.update_attributes(:new_position => 2)
  end

  it "returns them in the correct position" do
    [first,second,third].map(&:reload)
    List.by_position.should == [first, second, third]
  end
end

describe List, ".owned_by?" do
  let(:user) { create(:user_with_list) }
  let(:other_user) { create(:user) }
  let(:list_base) { list.list_base }
  let(:other_list) { create(:list, user: other_user, list_base: list_base) }
  let(:list) { user.lists.first }

  it "returns true for the owner" do
    list.owned_by?(user).should be_true
    other_list.owned_by?(user).should be_true
  end

  it "returns false for the other user" do
    list.owned_by?(other_user).should be_false
    other_list.owned_by?(other_user).should be_false
  end
end
