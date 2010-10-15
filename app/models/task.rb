class Task < ActiveRecord::Base
  belongs_to :list
  DATE_PATTERN = /@(\d{1,2}\/\d{1,2})/

  def title=(title)
    if title =~ DATE_PATTERN
      write_attribute(:due_date, parse_date_format($1))
    end
    write_attribute(:title, remove_date_format(title))
  end

  private

  def parse_date_format(str)
    Date.new(Time.now.year, *str.split('/').map(&:to_i).reverse)
  end

  def remove_date_format(str)
    str.gsub(%r{(\s+#{DATE_PATTERN}|#{DATE_PATTERN}\s+)}, '')
  end
end
