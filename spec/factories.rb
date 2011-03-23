Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |factory|
  factory.email                 { Factory.next :email }
  factory.password              { "password" }
  factory.password_confirmation { "password" }
end

Factory.define :list do |factory|
  factory.association :user
end

Factory.define :list_proxy do |factory|
  factory.association :list
  factory.association :user
  factory.after_create { |proxy| proxy.list.user = proxy.user; proxy.list.save }
end

Factory.define :additional_list_proxy, :class => "ListProxy" do |factory|
  factory.association :list
  factory.association :user
end

Factory.define :task do |factory|
  factory.title { "Task Title" }
  factory.association :list
end
