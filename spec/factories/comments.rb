FactoryBot.define do
  factory :comment do
    text { 'MyText' }
    user_id { 2 }
    item_id { 2 }

    trait :a do
      association :item
      user     { item.user }
    end

    trait :b do
      association :item
      association :user
    end
  end
end
