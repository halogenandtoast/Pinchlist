class Share
  attr_reader :user, :list

  def self.create(params)
    ActiveRecord::Base.transaction do
      list = List.find(params[:list_id])
      user = User.share_by_email(params[:email], list)
      list.proxies.create(:user => user)
    end
  end
end
