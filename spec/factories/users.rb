FactoryBot.define do
  factory :user do
    name { "user" }
    sequence(:email) { |n| "user#{n}@user.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end

  factory :admin_user, class: User do
    name { "admin_user" }
    sequence(:email) { |n| "admin#{n}@user.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
  end
end
