class Share
  include ActiveModel::Validations
  attr_accessor :email, :shared_list, :user
  validates :email, format: {with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/i, message: "Invalid email address"}

  def initialize(params = {})
    @shared_list = List.find(params[:list_id])
    @email = params[:email]
    @current_user_id = params[:current_user_id]
  end

  def as_json(options = {})
    {
      list_id: @shared_list.id,
      email: @email
    }
  end

  def save
    if valid?
      ActiveRecord::Base.transaction do
        @user = User.find_or_create_by(email: email)
        mail = if @user.new_record?
          @user.invitation_to_share(@shared_list).tap do
            Invitation.create(user_id: @current_user_id, invited_user_id: @user.id)
          end
        else
          MemberMailer.share_list_email(user: @user, list: @shared_list)
        end
        @shared_list.share_with(@user)
        mail.deliver
      end
      true
    else
      false
    end
  end
end
