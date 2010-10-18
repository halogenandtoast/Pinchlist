Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |user|
  user.email                 { Factory.next :email }
  user.password              { "password" }
  user.password_confirmation { "password" }
end

Factory.define :list do |list|
  list.association :user
end

Factory.define :task do |task|
  task.title { "Task Title" }
  task.association :list
end
