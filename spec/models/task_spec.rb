require 'spec_helper'

describe Task do
  it { should belong_to :list }
  it { should validate_presence_of :title }
end

describe Task, 'whose title has a due date' do
  context 'in the front' do
    subject { Factory(:task, :title => "@10/20 Build foo") }
    its(:due_date) { should == "20/10/#{Time.now.year}".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'in the back' do
    subject { Factory(:task, :title => "Build foo @10/20") }
    its(:due_date) { should == "20/10/#{Time.now.year}".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'in the middle' do
    subject { Factory(:task, :title => "Build @10/20 foo") }
    its(:due_date) { should == "20/10/#{Time.now.year}".to_date }
    its(:title) { should == 'Build foo' }
  end
end

describe Task, 'whose title has an invalid date' do
  subject { Factory(:task, :title => "@20/10 Build foo") }
  its(:due_date) { should_not be }
  its(:title) { should == "@20/10 Build foo" }
end
