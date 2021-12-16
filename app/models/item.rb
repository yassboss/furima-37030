class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_charge
  belongs_to :prefecture
  belongs_to :days_to_ship
  belongs_to :user

  VALID_PRICE_REGEX = /\A[0-9]+\z/.freeze

  with_options presence: true do
    validates :item_name, :description
    validates :price,
              length: { minimum: 300, maximum: 9999999 }, allow_blank: true,
              format: { with: VALID_PRICE_REGEX, allow_blank: true }
  end

  validates :category_id, :condition_id, :prefecture_id, :shipping_charge_id, :days_to_ship_id, numericality: { other_than: 1 , message: "can't be blank" }

end
