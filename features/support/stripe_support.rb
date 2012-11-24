FakeWeb.register_uri(:get, "https://api.stripe.com/v1/plans/1", :body => "Hello World!")
