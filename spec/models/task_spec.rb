require 'spec_helper'

describe Task do
  it { should belong_to :list }
end

describe Task, 'whose title has a due date' do
  context 'in the front' do
    subject { Factory(:task, :title => "@20/10 Build foo") }
    its(:due_date) { should == "20/10/#{Time.now.year}".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'in the back' do
    subject { Factory(:task, :title => "Build foo @20/10") }
    its(:due_date) { should == "20/10/#{Time.now.year}".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'in the middle' do
    subject { Factory(:task, :title => "Build @20/10 foo") }
    its(:due_date) { should == "20/10/#{Time.now.year}".to_date }
    its(:title) { should == 'Build foo' }
  end
end
