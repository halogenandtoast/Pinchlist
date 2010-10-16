class Task < ActiveRecord::Base
  DATE_PATTERN = /@([^\s]+)/
  MONTH_DAY_FORMAT = /(\d{1,2}\/\d{1,2})/

  belongs_to :list
  validates_presence_of :title

  scope :upcoming, where("tasks.due_date IS NOT NULL").order("tasks.due_date asc")

  def title=(title)
    parse_date_format(title)
    write_attribute(:title, remove_date_format(title))
  end

  private

  def parse_date_format(str)
    write_attribute(:due_date, date_from_format($1)) if str =~ DATE_PATTERN
  end

  def date_from_format(str)
    Chronic.parse(str.gsub(MONTH_DAY_FORMAT) { |date| "#{date}/#{Time.now.year}" }).try(:to_date)
  end

  def remove_date_format(str)
    self.due_date ? str.try(:gsub, %r{(\s+#{DATE_PATTERN}|#{DATE_PATTERN}\s+)}, '') : str
  end
end
