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
    let!(:list) { subject.list.target }
    before do
      list.stubs(:check_for_proxies)
    end

    it 'notifies the list' do
      subject.destroy
      list.should have_received(:check_for_proxies)
    end
  end
end

describe ListProxy, "#title" do
  let!(:list) { Factory(:list, :title => "Foo bar") }
  subject { Factory(:list_proxy, :list => list) }
  its(:title) { should == list.title }
end
