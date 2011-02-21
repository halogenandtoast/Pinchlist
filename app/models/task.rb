require 'timelord'
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
      parse_date_format(title) unless title =~ /^!/
    end
    write_attribute(:title, remove_date_format(title))
  end

  def display_title
    title.gsub(/^!/, '')
  end

  def new_position=(position)
    self.insert_at(position)
  end

  def list_color_for(user)
    user.proxy_for(list).color
  end

  def as_json(options)
    user = options.delete(:user)
    {:task => {:id => id, :display_title => display_title, :title => title, :list_id => list_id, :list_color => list_color_for(user)}.merge(due_date ? {:due_date => due_date.strftime("%m/%d"), :full_date => due_date.strftime("%y/%m/%d")} : {})}
  end

  private

  def parse_date_format(str)
    self.due_date = Timelord.parse(str, :american)
  rescue
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
