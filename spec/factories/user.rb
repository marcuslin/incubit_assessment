FactoryBot.define do
  factory :user do
    email { "user@mail.test" }
    password { 'password' }
    password_confirmation { 'password' }

    factory :invalid_email do
      email { "user" }
    end

    factory :invalid_password do
      password { "pwd" }
      password_confirmation { 'pwd' }
    end

    factory :invalid_confirmation do
      password { "password" }
      password_confirmation { 'pwd' }
    end
  end

end
