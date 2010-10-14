require 'spec_helper'

describe Task do
  it { should belong_to :list }
end

describe Task, 'title' do
  subject { Factory(:task, :title => "Build foo @20/10") }
  its(:due_date) { should == "20/10/#{Time.now.year}".to_date }
end
