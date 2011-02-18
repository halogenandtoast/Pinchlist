require 'spec_helper'

describe Task do
  it { should belong_to :list }
  # it { should validate_presence_of :title }

  it "requires title on create" do
    task = Task.new
    task.should_not be_valid
    task.errors[:title].should == ["can't be blank"]
  end

  context 'the first task' do
    it 'should start at order 1' do
      task = Factory(:task)
      task.position.should == 1
    end
  end

  context 'additional tasks' do
    it 'should start at the correct order' do
      user = Factory(:user)
      list = Factory(:list)
      first, second, third = [*1..3].map{|i| Factory(:task, :list => list) }
      first.position.should == 1
      second.position.should == 2
      third.position.should == 3
    end
  end
end

describe Task, 'with an empty title' do
  subject { Factory(:task) }
  it 'destroys itself' do
    subject.title = ""
    subject.save
    subject.should be_destroyed
  end
end

describe Task, 'whose title has a due date' do
  context 'in the front' do
    subject { Factory(:task, :title => "@10/20 Build foo") }
    its(:due_date) { should == "10/20/#{Time.now.year}".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'in the back' do
    subject { Factory(:task, :title => "Build foo @10/20") }
    its(:due_date) { should == "10/20/#{Time.now.year}".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'in the middle' do
    subject { Factory(:task, :title => "Build @10/20 foo") }
    its(:due_date) { should == "10/20/#{Time.now.year}".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'but starts with a !' do
    subject { Factory(:task, :title => "!Build @10/20 foo") }
    its(:due_date) { should == nil }
    its(:title) { should == '!Build @10/20 foo' }
  end
end

describe Task, 'whose title has an invalid date' do
  subject { Factory(:task, :title => "@31/31 Build foo") }
  its(:due_date) { should_not be }
  its(:title) { should == "@31/31 Build foo" }
end

describe Task, 'whose title has a chronic date format' do
  before { Timecop.freeze("10/16/10") }
  subject { Factory(:task, :title => "@wednesday do something") }
  its(:due_date) { should == Chronic.parse("wednesday").to_date }
  its(:title) { should == "do something" }
  after { Timecop.return }
end

describe Task, 'whose title is changed from having a due date to not having one' do
  before { Timecop.freeze("10/16/10") }
  subject { Factory(:task, :title => "@10/20 Do foo") }
  it "should remove the due date" do
    subject.title = "Do foo"
    subject.due_date.should be_nil
  end
  after { Timecop.return }
end

describe Task, '#upcoming' do
  before do
    @upcoming_tasks = [*1..3].map { Factory(:task, :title => "@10/20 do foo") }
    @other_tasks = [*1..3].map { Factory(:task, :title => "Other things") }
  end
  it 'knows upcoming tasks' do
    Task.upcoming.should == @upcoming_tasks
  end
end

describe Task, 'completed' do
  subject { Factory(:task) }
  before { Timecop.freeze(Date.parse("October 16, 2010")) }
  it 'sets its completed at date' do
    subject.update_attributes({:completed => true})
    subject.completed_at.should == "2010-10-16".to_date
  end
  after { Timecop.return }
end

describe Task, '#list_color' do
  let!(:list) { Factory(:list) }
  subject { Factory(:task, :list => list) }
  its(:list_color) { should == list.color }
end

describe Task, '#display_title' do
  context "title that starts with !"
  subject { Factory(:task, :title => "!foo 25th") }
  its(:display_title) { should == "foo 25th" }
end
