class Discussion < ActiveRecord::Base
  belongs_to :category, class_name: 'DiscussionCategory'
  belongs_to :user
  has_many :events, class_name: 'DiscussionEvent', dependent: :destroy
  validate :email_or_user

  def self.public
    where(private: false)
  end

  def close
    self.closed = true
    save
  end

  def reopen
    self.closed = false
    save
  end

  def email
    user.try(:email) || read_attribute(:email)
  end

  private

  def email_or_user
    if email.blank? && user_id.blank?
      errors.add(:base, "You must supply an email")
    end
  end
end
