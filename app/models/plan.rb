class Plan < ActiveRecord::Base
  has_many :subscriptions

  def self.basic
    where(name: "Basic").first
  end
end
