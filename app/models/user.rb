class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :items
  has_many :comments

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  VALID_NAME_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/.freeze
  VALID_NAME_READING_REGEX = /\A[ァ-ヶー]+\z/.freeze
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze

  validates_format_of :password, with: VALID_PASSWORD_REGEX, message: 'は英字と数字の両方を含めて設定してください',
                                 allow_blank: true

  with_options presence: true do
    validates :nickname, :birthday
    validates :last_name, :first_name,
              format: { with: VALID_NAME_REGEX, message: 'は全角文字を入力してください', allow_blank: true }
    validates :last_name_reading, :first_name_reading,
              format: { with: VALID_NAME_READING_REGEX, message: 'は全角カナ文字を入力してください', allow_blank: true }
  end
end
