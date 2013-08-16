require 'timelord'
class Task < ActiveRecord::Base
  DATE_PATTERN = /@([^\s]+)/
  MONTH_DAY_FORMAT = /(\d{1,2}\/\d{1,2})/
  DAYNAMES = Date::DAYNAMES+Date::ABBR_DAYNAMES+['tues','thurs','thur','tod','today','tom','tomorrow']
  MONTHNAMES = (Date::MONTHNAMES+Date::ABBR_MONTHNAMES).compact
  REMOVE_DATE_MATCHER = /\b ((on|next) )?(((#{DAYNAMES.join("|")}))|((#{MONTHNAMES.join("|")})( \d{1,2})?)|(\d{1,2}\/\d{1,2}(\/\d{2}\d{2}?)?))\b/i

  belongs_to :list_base
  validates_presence_of :title, on: :create
  after_update :reposition
  after_create :move_before_completed
  after_save :destroy_on_empty_title

  scope :upcoming, -> { where("tasks.due_date IS NOT NULL AND tasks.completed = ?", false).order("tasks.due_date asc") }
  scope :completed, -> { where(completed: true) }
  acts_as_list scope: :list_base

  def update_attributes_with_list_swap(params)
    task_params = params.dup
    new_list_base_id = task_params.delete(:list_base_id)
    if new_list_base_id
      remove_from_list
      self.list_base_id = new_list_base_id
      move_to_bottom
    end
    update_attributes(task_params)
  end

  def self.by_position
    order("tasks.position ASC")
  end

  def self.filtered(filter)
    case filter
    when :current
      current
    else
      all
    end
  end

  def self.current
    where(["(tasks.completed = ? OR (tasks.completed_at IS NULL OR tasks.completed_at > ?))", false, 7.days.ago.to_date])
  end

  def title=(new_title)
    title = new_title.dup
    unless title.empty?
      if title =~ /^!/
        write_attribute(:due_date, nil)
      else
        parse_date_format(title) unless title =~ /^!/
      end
    end
    write_attribute(:title, remove_date_data(title))
  end

  def display_title
    title.gsub(/^!/, '')
  end

  def new_position=(position)
    self.insert_at(position)
  end

  def as_json(options = {})
    {
      id: id,
      display_title: display_title,
      title: title,
      list_base_id: list_base_id,
      position: position,
      completed: completed,
      archived: archived?
    }.merge(due_date ? {due_date: due_date.strftime("%m/%d"), full_date: due_date.strftime("%y/%m/%d")} : {})
  end

  def archived?
    self.completed_at && self.completed_at.to_datetime < 7.days.ago
  end

  def completed=(state)
    self[:completed] = state
    self.completed_at = state ? Date.today : nil
  end

  def list=(list)
    self.list_base_id = list.list_base.id
  end

  private

  def parse_date_format(str)
    Timelord.set_date(Time.zone.now.to_date)
    self.due_date = Timelord.parse(str, :american)
  rescue Exception => e
  end

  def date_from_format(str)
    Chronic.parse(str.gsub(MONTH_DAY_FORMAT) { |date| "#{date}/#{Time.now.year}" }).try(:to_date)
  end

  def remove_date_data(str)
    str.dup.tap do |s|
      if self.due_date
        s.try(:gsub!, %r{(\s+#{DATE_PATTERN}|#{DATE_PATTERN}\s+)}, '')
        s.try(:gsub!, REMOVE_DATE_MATCHER, '')
      end
    end
  end

  def destroy_on_empty_title
    destroy if title.empty?
  end

  def reposition
    move_before_completed if self.completed_changed?
  end

  def position_before_completed
    self['position'] = position_of_completed || task.list_base.tasks.count
  end

  def move_before_completed
    reload
    move_to_bottom
    if min = position_of_completed
      insert_at(min)
    end
  end

  def position_of_completed
    if self.id
      list_base.tasks.completed.where("id <> ?", self.id).minimum(:position)
    else
      list_base.tasks.completed.minimum(:position)
    end
  end
end
