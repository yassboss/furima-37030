FactoryBot.define do
  factory :comment do
    text { 'MyText' }
    user_id { 2 }
    item_id { 2 }
  end
end
