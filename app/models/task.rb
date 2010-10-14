class Task < ActiveRecord::Base
  belongs_to :list

  def title=(title)
    if title =~ /@(\d{1,2}\/\d{1,2}) (.*)/
      title = $2
      day, month = $1.split('/').map(&:to_i)
      write_attribute(:due_date, Date.new(Time.now.year, month, day))
    end
    write_attribute(:title, title)
  end
end
