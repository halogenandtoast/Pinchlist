module Listwerk
  module Subscription
    extend ActiveSupport::Concern

    included do
      attr_accessor :stripe_card_token
      attr_accessible :stripe_customer_token, :starts_at, :ends_at, :status
      belongs_to :plan
    end

    module InstanceMethods

      def subscription
        @subscription ||= ::Subscription.new(self)
      end

      def inactive?
        status == 'inactive'
      end

      def active?
        status == 'active'
      end

      def cancelled?
        status == 'cancelled'
      end

      def permanent?
        status == 'permanent'
      end

      def expired?
        status == 'expired'
      end

      def cancel_subscription!
        subscription.cancel!
        update_attributes(:status => 'cancelled')
      end

      def resubscribe!
        subscription.resubscribe!
        update_attributes(:status => 'active')
      end

      def subscribe!(options)
        self.stripe_card_token = options[:stripe_card_token]
        customer = subscription.create_customer(self)
        self.update_attributes(
          stripe_customer_token: customer.id,
          starts_at: Time.at(customer.subscription.current_period_start),
          ends_at: Time.at(customer.subscription.current_period_end),
          status: 'active'
        )
      rescue Stripe::InvalidRequestError => e
        logger.error "Stripe error while creating customer: #{e.message}"
        errors.add :base, "There was a problem with your credit card."
        false
      end

      def next_bill_date
        ends_at
      end

      def expiration_date
        ends_at
      end

      def subscribed?
        active? || permanent?
      end

    end
  end
end
