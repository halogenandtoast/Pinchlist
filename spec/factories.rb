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

  factory :list_base do
    user
  end

  factory :list do
    ignore do
      list_base
    end

    title "List"
    user
  end

  factory :task do
    title "Task Title"
    list_base
    ignore do
      list
    end

    factory :completed_task do
      completed true
    end
  end
end
