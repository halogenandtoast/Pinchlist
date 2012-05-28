class LockedList
  extend ActiveModel::Naming
  attr_reader :list
  def initialize list
    @list = list
  end

  delegate :list, :shared?, :color, :title, :list_id, :owner, to: :list

end
