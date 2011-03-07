class Share
  attr_reader :user
  def initialize(params)
    @list = List.find(params[:list_id])
    @email = params[:email]
  end

  def save
    @user = User.find_by_email!(@email)
    if @user = User.find_by_email!(@email)
      MemberMailer.share_list_email(:user => @user, :list => @list).deliver
    # else @user = User.invite_without_email!(:email => @email)
    #   MemberMailer.share_list_and_invite_email(:user => @user, :list => @list).deliver
    end
    @list.proxies.create(:user => @user)
  end
end
