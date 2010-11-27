class Task < ActiveRecord::Base
  DATE_PATTERN = /@([^\s]+)/
  MONTH_DAY_FORMAT = /(\d{1,2}\/\d{1,2})/

  belongs_to :list
  validates_presence_of :title, :on => :create
  before_update :set_completed_at
  after_save :destroy_on_empty_title

  scope :upcoming, where("tasks.due_date IS NOT NULL").order("tasks.completed, tasks.due_date asc")
  scope :current, lambda { where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", 7.days.ago.to_date]) }
  scope :by_status, order("tasks.completed ASC, tasks.position ASC")
  acts_as_list :scope => :list

  def title=(title)
    unless title.empty?
      parse_date_format(title)
    end
    write_attribute(:title, remove_date_format(title))
  end

  def new_position=(position)
    self.insert_at(position)
  end

  def as_json(options)
    {:task => {:id => id, :title => title}.merge(due_date ? {:due_date => due_date.strftime("%m/%d")} : {})}
  end

  private

  def parse_date_format(str)
    self.due_date = str =~ DATE_PATTERN ? date_from_format($1) : nil
  end

  def date_from_format(str)
    Chronic.parse(str.gsub(MONTH_DAY_FORMAT) { |date| "#{date}/#{Time.now.year}" }).try(:to_date)
  end

  def remove_date_format(str)
    self.due_date ? str.try(:gsub, %r{(\s+#{DATE_PATTERN}|#{DATE_PATTERN}\s+)}, '') : str
  end

  def destroy_on_empty_title
    if title.empty?
      destroy
    end
  end

  def set_completed_at
    unless destroyed?
      if self.completed && self.completed_changed?
        self.completed_at = Date.today
      else
        self.completed_at = nil
      end
    end
  end

end
