class LockedListProxy
  extend ActiveModel::Naming
  attr_reader :proxy
  def initialize proxy
    @proxy = proxy
  end

  delegate :list, :shared?, :color, :title, :list_id, :owner, to: :proxy

end
