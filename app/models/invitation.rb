class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :invited_user, class_name: 'User'
end
