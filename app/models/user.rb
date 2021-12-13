class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  NAME_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/.freeze
  NAME_READING_REGEX = /\A[ァ-ヶー]+\z/.freeze
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze

  with_options presence: true do
    validates :nickname, :birthday
    validates :last_name, :first_name, format: {with: NAME_REGEX, message: 'には全角（漢字・ひらがな・カタカナ）を使用してください', allow_blank: true}
    validates :last_name_reading, :first_name_reading, format: {with: NAME_READING_REGEX, message: 'には全角（カタカナ）を使用してください', allow_blank: true}
  end

  validates_format_of :password, with: PASSWORD_REGEX, message: 'には英字と数字の両方を含めて設定してください', allow_blank: true
end
