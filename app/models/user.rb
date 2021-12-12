class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  with_options presence: true do
    validates :nickname, :birthday
    validates :last_name, :first_name, format: {with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: '全角（漢字・ひらがな・カタカナ）を使用してください'}
    validates :last_name_reading, :first_name_reading, format: {with: /\A[ァ-ヶー]+\z/, message: '全角（カタカナ）を使用してください'}
  end
  validates :password, format: {with: /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i, message: '半角英数字混合で入力してください'}
end
