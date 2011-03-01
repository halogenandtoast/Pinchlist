require "spec_helper"

describe MemberMailer, "share_list_email" do
  let(:sharer) { Factory(:user) }
  let(:receiver) { Factory(:user) }
  let(:list) { Factory(:list, :user => sharer) }
  subject { MemberMailer.share_list_email(:user => receiver, :list => list) }
  it { should deliver_to(receiver.email) }
  it { should have_subject("A new list has been shared with you") }
  it { should have_body_text("#{sharer.email} shared the list #{list.title} with you.") }
end
