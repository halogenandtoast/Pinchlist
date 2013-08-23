class ListSerializer < ActiveModel::Serializer
  attributes :id, :title, :color, :public_token, :slug
  attributes :position, :shared, :shares, :public, :is_owner

  has_many :tasks

  def is_owner
    !!scope && (scope.id == object.owner.id)
  end

  def shared
    object.shared?
  end
end
