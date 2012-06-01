require 'spec_helper'

describe Task do
  it { should belong_to :list_base }
  # it { should validate_presence_of :title }

  it "requires title on create" do
    task = Task.new
    task.should_not be_valid
    task.errors[:title].should == ["can't be blank"]
  end

  context 'the first task' do
    it 'should start at order 1' do
      task = create(:task)
      task.position.should == 1
    end
  end

  context 'additional tasks' do
    it 'should start at the correct order' do
      user = create(:user)
      list = create(:list)
      first, second, third = [*1..3].map{|i| create(:task, :list_base => list.list_base) }
      first.position.should == 1
      second.position.should == 2
      third.position.should == 3
    end
  end
end

describe Task, 'with an empty title' do
  subject { create(:task) }
  it 'destroys itself' do
    subject.title = ""
    subject.save
    subject.should be_destroyed
  end
end

describe Task, 'whose title has a due date' do
  before do
    Timecop.freeze(2011, 10, 1)
  end

  context 'in the front' do
    subject { create(:task, :title => "@10/20 Build foo") }
    its(:due_date) { should == "#{Time.now.year}/10/20".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'in the back' do
    subject { create(:task, :title => "Build foo @10/20") }
    its(:due_date) { should == "#{Time.now.year}/10/20".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'in the middle' do
    subject { create(:task, :title => "Build @10/20 foo") }
    its(:due_date) { should == "#{Time.now.year}/10/20".to_date }
    its(:title) { should == 'Build foo' }
  end

  context 'but starts with a !' do
    subject { create(:task, :title => "!Build @10/20 foo") }
    its(:due_date) { should == nil }
    its(:title) { should == '!Build @10/20 foo' }
  end

  after do
    Timecop.return
  end
end

describe Task, 'whose title has an invalid date' do
  subject { create(:task, :title => "@31/31 Build foo") }
  its(:due_date) { should_not be }
  its(:title) { should == "@31/31 Build foo" }
end

describe Task, 'whose title has a chronic date format' do
  before { Timecop.freeze("2010/16/10") }
  subject { create(:task, :title => "@wednesday do something") }
  its(:due_date) { should == Chronic.parse("wednesday").to_date }
  its(:title) { should == "do something" }
  after { Timecop.return }
end

describe Task, 'whose title is changed from having a due date to not having one' do
  before { Timecop.freeze("2010/16/10") }
  subject { create(:task, :title => "@10/20 Do foo") }
  it "should remove the due date" do
    subject.title = "Do foo"
    subject.due_date.should be_nil
  end
  after { Timecop.return }
end

describe Task, '#upcoming' do
  before do
    @upcoming_tasks = [*1..3].map { create(:task, :title => "@10/20 do foo") }
    @other_tasks = [*1..3].map { create(:task, :title => "Other things") }
  end
  it 'knows upcoming tasks' do
    Task.upcoming.should == @upcoming_tasks
  end
end

describe Task, 'completed' do
  subject { create(:task, :title => "THE SUBJECT") }
  before { Timecop.freeze(Date.parse("October 16, 2010")) }
  it 'sets its completed at date' do
    subject.update_attributes({:completed => true})
    subject.completed_at.should == "2010-10-16".to_date
  end
  context "position" do
    let!(:user) { subject.list_base.user }
    before { 2.times { create(:task, :list_base => subject.list_base) } }
    context "with other completed tasks" do
      before { 2.times { create(:task, :list_base => subject.list_base, :completed => true) } }
      it 'is in the correct position' do
        subject.update_attributes(:completed => true)
        subject.position.should == 3
      end
    end
    context "without other completed tasks" do
      it 'is in the correct position' do
        subject.update_attributes(:completed => true)
        subject.position.should == 3
      end
    end
  end
  after { Timecop.return }
end

# describe Task, '#list_color_for' do
#   let!(:list) { create(:list) }
#   let!(:list_base) { list.list_base }
#   let!(:user) { list.user }
#   subject { create(:task, :list_base => list_base) }
#   it "should retrieve the color for the user" do
#     subject.list_color_for(user).should == list_proxy.color
#   end
# end

describe Task, '#display_title' do
  context "title that starts with !"
  subject { create(:task, :title => "!foo 25th") }
  its(:display_title) { should == "foo 25th" }
end

describe Task, '.filtered' do
  before { Task.stubs(:current) }
  context "when none" do
    it "does not call additional filters" do
      Task.filtered(:none)
      Task.should have_received(:current).never
    end
  end

  context "when current" do
    it "calls the current filter" do
      Task.filtered(:current)
      Task.should have_received(:current)
    end
  end
end

describe Task, ".create" do
  let!(:list) { create(:list) }
  subject { build(:task, :list_base => list.list_base) }
  before do
    create(:task, :list_base => list.list_base)
    create(:completed_task, :list_base => list.list_base)
  end
  it "inserts before completed tasks" do
    subject.save
    subject.position.should == 2
  end
end

describe Task, "#update" do
  subject { create(:task, :title => "Do stuff on 10/10") }
  it "removes the date when ! is added" do
    subject.update_attributes(:title => "!Do stuff on 10/10")
    subject.due_date.should be_nil
  end
end

describe Task, "#title=" do
  subject { create(:task) }
  let(:titles) { ["Do stuff on Monday", "Do stuff next friday", "Do stuff Feb 24", "Do stuff 2/24", "Do stuff 2/24/03", "Do stuff 02/24/2003"] }
  it "removes the date string" do
    titles.each do |title|
      subject.title = title
      subject.title.should eql("Do stuff"), %{"#{title}" should have changed to "Do stuff" got "#{subject.title}" instead}
    end
  end
end
