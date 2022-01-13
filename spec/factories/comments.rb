FactoryBot.define do
  factory :comment do
    text { 'MyText' }

    trait :assoc do
      association :item
      association :user
    end

    trait :assoc_user do
      association :user
    end

    trait :item_assoc do
      association :item
      user { item.user }
    end
  end
end
