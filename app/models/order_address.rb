class OrderAddress
  include ActiveModel::Model
  attr_accessor :item_id, :user_id, :postal_code, :prefecture_id, :city, :house_number, :building_name, :phone_number, :token,
                :price

  VALID_POSTAL_CODE_REGEX = /\A[0-9]{3}-[0-9]{4}\z/

  with_options presence: true do
    validates :token
    validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX, message: 'is invalid. Enter it as follows (e.g. 123-4567)' }
    validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }
    validates :item_id, :user_id, :city, :house_number
    validates :phone_number,
              length: { in: 10..11, allow_blank: true },
              numericality: { only_integer: true, allow_blank: true }
  end

  def save
    order = Order.create(item_id: item_id, user_id: user_id)
    Address.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city, house_number: house_number, building_name: building_name,
                   phone_number: phone_number, order_id: order.id)
  end
end
