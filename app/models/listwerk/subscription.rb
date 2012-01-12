module Listwerk
  module Subscription
    extend ActiveSupport::Concern
    included do
      has_many :subscriptions
    end

    module InstanceMethods
      def current_subscription
        subscriptions.current.first
      end

      def active?
        subscribed? && (current_subscription.active? || permanent?)
      end

      def cancelled?
        subscribed? && current_subscription.cancelled? && !permanent?
      end

      def cancel_subscription!
        current_subscription.cancel!
      end

      def resubscribe!
        current_subscription.resubscribe!
      end

      def next_bill_date
        current_subscription.ends_at
      end

      def expiration_date
        current_subscription.ends_at
      end

      def subscribed?
        current_subscription || permanent?
      end
    end
  end
end
