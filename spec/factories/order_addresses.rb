FactoryBot.define do
  factory :order_address do
    postal_code        { '123-4567' }
    prefecture_id      { Faker::Number.between(from: 2, to: 48) }
    city               { Faker::Address.city }
    house_number       { '町1-2-3' }
    building_name      { 'ビル名' }
    phone_number       { '00000000000' }
  end
end
