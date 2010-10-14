require 'spec_helper'

describe Task do
  it { should belong_to :list }
end

describe Task, 'title with due date' do
  subject { Factory(:task, :title => "@20/10 Build foo") }
  its(:due_date) { should == "20/10/#{Time.now.year}".to_date }
end
