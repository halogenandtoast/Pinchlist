require 'spec_helper'

describe List do
  it { should belong_to :user }
  it { should have_many(:tasks).dependent(:destroy) }

  context 'the first list' do
    it 'should start at order 1' do
      list = Factory(:list)
      list.position.should == 1
    end
  end

  context 'additional lists' do
    it 'should start at the correct order' do
      user = Factory(:user)
      first, second, third = [*1..3].map{|i| Factory(:list, :user => user) }
      first.position.should == 1
      second.position.should == 2
      third.position.should == 3
    end
  end
end
