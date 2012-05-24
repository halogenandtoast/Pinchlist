class DiscussionCategory < ActiveRecord::Base
  has_many :discussions, foreign_key: :category_id
end
