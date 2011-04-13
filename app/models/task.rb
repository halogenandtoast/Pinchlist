require 'timelord'
class Task < ActiveRecord::Base
  DATE_PATTERN = /@([^\s]+)/
  MONTH_DAY_FORMAT = /(\d{1,2}\/\d{1,2})/

  belongs_to :list
  validates_presence_of :title, :on => :create
  before_update :set_completed_attributes
  after_update :reposition
  after_create :position_before_completed
  after_save :destroy_on_empty_title

  scope :upcoming, where("tasks.due_date IS NOT NULL").order("tasks.completed, tasks.due_date asc")
  scope :completed, where(:completed => true)
  scope :by_status, order("tasks.completed ASC, tasks.position ASC")
  acts_as_list :scope => :list

  def self.by_position
    order("tasks.position ASC")
  end

  def self.filtered(filter)
    case filter
    when :current
      current
    end
  end

  def self.current
    where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", 7.days.ago.to_date])
  end

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

  def set_completed_attributes
    unless destroyed?
      if self.completed && self.completed_changed?
        self.completed_at = Date.today
      elsif self.completed_changed?
        self.completed_at = nil
      end
    end
  end

  def reposition
    unless destroyed?
      if self.completed && self.completed_changed?
        reload
        if min = list.tasks.completed.where("id <> ?", self.id).minimum(:position)
          insert_at(min-1)
        else
          move_to_bottom
        end
      end
    end
  end

  def position_before_completed
    if min = list.tasks.completed.where("id <> ?", self.id).minimum(:position)
      insert_at(min)
    end
  end

end
