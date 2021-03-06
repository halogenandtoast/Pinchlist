require 'spec_helper'

describe ListBase do
  it { should belong_to :user }
  it { should have_many(:tasks).dependent(:destroy) }
  it { should have_many(:lists) }
  it { should have_many(:users).through(:lists) }

  # context 'when saved' do
  #   it 'creates a list proxy for the user' do
  #     user = create(:user)
  #     list = create(:list, :user => user)
  #     list.proxies.first.user.should == user
  #   end
  # end

  # describe 'updated' do
  #   context 'with empty title' do
  #     subject { create(:list) }
  #     it 'should set the title to the id' do
  #       subject.title = ""
  #       subject.title.should == "List #{subject.id}"
  #     end
  #   end
  # end
end

describe ListBase, '#check_for_lists' do
  subject { create(:list_base) }
  context 'with more proxies' do
    before do
      subject.stubs(:lists).returns([1])
      subject.stubs(:destroy)
    end
    it "does not destroy the list" do
      subject.check_for_lists
      subject.should have_received(:destroy).never
    end
  end
  context 'without more proxies' do
    before do
      subject.stubs(:lists).returns([])
      subject.stubs(:destroy)
    end
    it "destroys the list" do
      subject.check_for_lists
      subject.should have_received(:destroy)
    end
  end
end

describe ListBase, '#shared_users' do
  let(:user) { create(:user) }
  let(:expected_users)  { 3.times.map { create(:user) } }
  subject { create(:list_base, user: user) }
  before do
    expected_users.each { |user| create(:list, list_base: subject, user: user) }
  end
  it "contains the correct users" do
    subject.shared_users.to_a.should =~ expected_users
  end
end

describe ListBase, '#shared?' do
  subject { create(:list).list_base }
  context "when not shared" do
    it "is not shared" do
      subject.shared?.should be_false
    end
  end

  context "when shared" do
    before { create(:list, list_base: subject) }
    it "is shared" do
      subject.shared?.should be_true
    end
  end
end
