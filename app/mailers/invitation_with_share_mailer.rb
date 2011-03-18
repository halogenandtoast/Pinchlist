class InvitationWithShareMailer < ActionMailer::Base
  default :from => "support@listwerk.com"

  def invitation_for(user, list)
    @user = user
    @list = list
    mail(:to => user.email,
         :subject => "You have been invited to the list #{list.title}")
  end
end
