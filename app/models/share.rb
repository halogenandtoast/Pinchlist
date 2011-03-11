class Share
  attr_reader :user, :list
  def initialize(user, list)
    @user = user
    @list = list
  end

  def self.create(params)
    transaction do
      list = List.find(params[:list_id])
      user = User.share_by_email(params[:email])
      Share.new(user, list).tap do |share|
        list.proxies.create(:user => user)
      end
    end
  end
end
