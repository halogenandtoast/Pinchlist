require 'mocha'
Before do
  @mock = mock
  Stripe.mock_rest_client = @mock
end

After do
  Stripe.mock_rest_client = nil
end

module Stripe
  @mock_rest_client = nil
  def self.mock_rest_client=(mock_client)
    @mock_rest_client = mock_client
  end

  def self.execute_request(opts)
    $stdout.puts "FUCKING HERE"
    get_params = (opts[:headers] || {})[:params]
    post_params = opts[:payload]
    case opts[:method]
    when :get then @mock_rest_client.get opts[:url], get_params, post_params
    when :post then @mock_rest_client.post opts[:url], get_params, post_params
    when :delete then @mock_rest_client.delete opts[:url], get_params, post_params
    end
  end
end
