class InvitationWithShareMailer < ActionMailer::Base
  default :from => "support@listwerk.com"

  def invitation_for(user, list)
    @invitee = user
    @list = list
    @inviter = @list.user
    mail(:to => user.email,
         :subject => "You have been invited to the list #{list.title}")
  end
end
