class Discount < ActiveRecord::Base
  belongs_to :user
  after_create :apply_credit
  def self.unused
    where(used: false)
  end

  private

  def apply_credit
    user.available_credit += amount
    user.save
  end
end
