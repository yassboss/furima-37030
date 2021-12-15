require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できる場合' do
      it "必要項目が全て存在すれば登録できる" do
        expect(@user).to be_valid
      end
      it "passwordが6文字以上の英数字混合であれば登録できる" do
        @user.password = '1234test'
        @user.password_confirmation = '1234test'
        expect(@user).to be_valid
      end
    end
    context '新規登録できない場合' do
      it "nicknameが空では登録できない" do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      it "emailが空では登録できない" do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it "passwordが空では登録できない" do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it "last_nameが空では登録できない" do
        @user.last_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank")
      end
      it "first_nameが空では登録できない" do
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name can't be blank")
      end
      it "last_name_readingが空では登録できない" do
        @user.last_name_reading = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name reading can't be blank")
      end
      it "first_name_readingが空では登録できない" do
        @user.first_name_reading = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name reading can't be blank")
      end
      it "birthdayが空では登録できない" do
        @user.birthday = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Birthday can't be blank")
      end
      it "last_nameが全角（漢字・ひらがな・カタカナ）以外では登録できない" do
        @user.last_name = 'ﾃｽﾄ'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name is invalid. Input full-width characters")
      end
      it "first_nameが全角（漢字・ひらがな・カタカナ）以外では登録できない" do
        @user.first_name = 'shimasu'
        @user.valid?
        expect(@user.errors.full_messages).to include("First name is invalid. Input full-width characters")
      end
      it "last_name_readingが全角（カタカナ）以外では登録できない" do
        @user.last_name_reading = 'てすと'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name reading is invalid. Input full-width katakana characters")
      end
      it "first_name_readingが全角（カタカナ）以外では登録できない" do
        @user.first_name_reading = 'ｼﾏｽ'
        @user.valid?
        expect(@user.errors.full_messages).to include("First name reading is invalid. Input full-width katakana characters")
      end
      it "passwordが5文字以下であれば登録できない" do
        @user.password = '1234t'
        @user.password_confirmation = '1234t'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end
      it "passwordが半角英数字混合でなければ登録できない" do
        @user.password = '12345Ｙ'
        @user.password_confirmation = '12345Ｙ'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid. Include both letters and numbers")
      end
      it "passwordとpassword_confirmationが不一致であれば登録できない" do
        @user.password = '1234test'
        @user.password_confirmation = '12345test'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it "重複したemailが存在する場合は登録できない" do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Email has already been taken")
      end
      it "emailに@を含まない場合は登録できない" do
        @user.email = 'test.com'
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end
    end
  end
end
