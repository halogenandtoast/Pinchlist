class MemberMailer < ActionMailer::Base
  default :from => "from@example.com"
  def share_list_email(options)
    user = options[:user]
    @list = options[:list]
    @sender = @list.user
    mail(:to => user.email,
         :from => @sender.email,
         :subject => "A new list has been shared with you")
  end

  def update_clicks_email(user)
    mail(:to => user.email,
         :from => "support@listwerk.com",
         :subject => "Listwerk updates")
  end

end
