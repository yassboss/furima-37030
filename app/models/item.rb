class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_charge
  belongs_to :prefecture
  belongs_to :days_to_ship
  belongs_to :user
  has_one_attached :image
  has_many :comments
  has_many :Notifications, dependent: :destroy

  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(item_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    unless temp_ids.include?(user.id)
      save_notification_comment!(current_user, comment_id, user_id)
    end
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      item_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  VALID_PRICE_REGEX = /\A[0-9]+\z/

  with_options presence: true do
    validates :item_name, :description, :image
    validates :price,
              numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999, only_integer: true,
                              allow_blank: true },
              format: { with: VALID_PRICE_REGEX, allow_blank: true }
  end

  validates :category_id, :condition_id, :prefecture_id, :shipping_charge_id, :days_to_ship_id,
            numericality: { other_than: 1, message: "can't be blank" }
end
