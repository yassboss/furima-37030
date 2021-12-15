FactoryBot.define do
  factory :user do
    nickname              {Faker::Name}
    email                 {Faker::Internet.free_email}
    password              {'boss1234'}
    password_confirmation {password}
    last_name             {'久くク'}
    first_name            {'日ひヒ'}
    last_name_reading     {'テスト'}
    first_name_reading    {'シマス'}
    birthday              {'2020-01-01'}
  end
end
