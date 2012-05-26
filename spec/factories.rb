FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }

  factory :user do
    email
    password "password"
    password_confirmation "password"

    factory :user_with_list do
      after(:create) do |user|
        create(:list, user: user)
      end
    end
  end

  factory :list do
    title "List"
    user
  end

  factory :list_proxy do
    ignore do
      list
    end

    user
  end

  factory :task do
    title "Task Title"
    list

    factory :completed_task do
      completed true
    end
  end
end
