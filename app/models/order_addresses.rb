class OrderAddresses
  include ActiveModel::Model
  attr_accessor :item_id, :user_id, :postal_code, :prefecture, :city, :house_number, :building_name, :phone_number, :order_id

  VALID_POSTAL_CODE_REGEX = /\A[0-9]{3}-[0-9]{4}\z/
  VALID_PHONE_NUMBER_REGEX = /\A[0-9]+\z/

  with_options presence: true do
    validates :item_id, :user_id, :city, :house_number, :order_id
    validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX, message: 'is invalid. Enter it as follows (e.g. 123-4567)' }
    validates :phone_number,
              numericality: { greater_than_or_equal_to: 10, less_than_or_equal_to: 11, only_integer: true,
                              allow_blank: true },
              format: { with: VALID_PHONE_NUMBER_REGEX, allow_blank: true }
  end
  validates :prefecture, numericality: { other_than: 1, message: "can't be blank" }

  def save
    order = Order.create(item_id: item_id, user_id: user_id)
    Address.create(prefecture: prefecture, city: city, house_number: house_number, building_name: building_name,
                   phone_number: phone_number, order_id: order.id)
  end
end
