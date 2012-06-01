require 'spec_helper'

describe User do
  it { should have_many(:lists) }
  it { should have_many(:list_bases).through(:lists) }
  it { should have_many(:owned_lists) }
end

describe User, '#list_for' do
  subject { create(:user) }
  let(:list_base) { create(:list_base, user: subject) }
  let(:list) { mock("list") }
  let(:lists) { mock("lists") }

  before do
    lists.stubs(:find_by_list_base_id).with(list_base.id).returns(list)
    subject.stubs(:lists).returns(lists)
  end

  it "returns the correct proxy when given a list object" do
    subject.list_for(list_base).should == list
  end

  it "returns the correct proxy when given a list id" do
    subject.list_for(list_base.id).should == list
  end
end

describe User, "#tasks" do
  subject { create(:user) }
  let!(:list) { create(:list, user: subject) }
  let!(:tasks) { 3.times.map { create(:task, list_base: list.list_base) } }
  before do
    3.times { create(:task) }
  end
  it "returns the correct tasks" do
    subject.tasks.to_a =~ tasks
  end
end
