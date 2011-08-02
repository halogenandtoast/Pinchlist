class Share
  include ActiveModel::Validations
  attr_accessor :email, :shared_list
  validates :email, :format => {:with => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/, :message => "Invalid email address"}

  def initialize(params = {})
    @shared_list = List.find(params[:list_id])
    @email = params[:email]
  end

  def save
    ActiveRecord::Base.transaction do
      user = User.share_by_email(@email, @shared_list)
      @shared_list.proxies.create(:user => user)
    end
  end
end
