require 'json'
class InvoicesController < ApplicationController
  def create
    json = JSON.parse(request.raw_post)
    if json["type"] == "invoice.created"
      invoice_id = json["data"]["object"]["id"]
      stripe_customer_token = json["data"]["object"]["customer"]
      amount = json["data"]["object"]["amount_due"]
      user = User.find_by_stripe_customer_token(stripe_customer_token)
      if user.has_credit?
        credit = [user.available_credit, amount].min
        user.use_credit(credit)
        Stripe::InvoiceItem.create(
          :customer => stripe_customer_token,
          :amount => credit * -1,
          :currency => "usd",
          :description => "Credit for inviting paid user",
          :invoid => invoice_id
        )
      end
    end
    render json: "ok"
  end
end
