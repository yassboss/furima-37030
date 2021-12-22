require 'rails_helper'

RSpec.describe OrderAddress, type: :model do
  describe '配送先の登録' do
    before do
      user = FactoryBot.create(:user)
      item = FactoryBot.create(:item)
      @order_address = FactoryBot.build(:order_address, item_id: item.id, user_id: user.id)
      sleep 0.1
    end

    context '配送先登録できる場合' do
      it '必要項目が全て存在すれば登録できる' do
        expect(@order_address).to be_valid
      end
      it '電話番号が10桁の半角数値であれば登録できる' do
        @order_address.phone_number = '1234567890'
        expect(@order_address).to be_valid
      end
      it '電話番号が11桁の半角数値であれば登録できる' do
        @order_address.phone_number = '12345678912'
        expect(@order_address).to be_valid
      end
      it '建物名が空でも登録できる' do
        @order_address.building_name = ''
        expect(@order_address).to be_valid
      end
    end

    context '配送先登録できない場合' do
      it '郵便番号が空では登録できない' do
        @order_address.postal_code = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Postal code can't be blank")
      end
      it '郵便番号が「3桁ハイフン4桁」の半角文字列でなければ登録できない' do
        @order_address.postal_code = '1234567'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('Postal code is invalid. Enter it as follows (e.g. 123-4567)')
      end
      it '都道府県が空では登録できない' do
        @order_address.prefecture_id = 1
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Prefecture can't be blank")
      end
      it '市区町村が空では登録できない' do
        @order_address.city = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("City can't be blank")
      end
      it '番地が空では登録できない' do
        @order_address.house_number = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("House number can't be blank")
      end
      it '電話番号が空では登録できない' do
        @order_address.phone_number = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Phone number can't be blank")
      end
      it '電話番号が10桁未満では登録できない' do
        @order_address.phone_number = '123456789'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('Phone number is too short (minimum is 10 characters)')
      end
      it '電話番号が12桁以上では登録できない' do
        @order_address.phone_number = '123456789123'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('Phone number is too long (maximum is 11 characters)')
      end
      it '電話番号に数字以外が含まれていれば登録できない' do
        @order_address.phone_number = '123-4567-89'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('Phone number is not a number')
      end
      it 'itemが紐づいていないと保存できない' do
        @order_address.item_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Item can't be blank")
      end
      it 'userが紐づいていないと保存できない' do
        @order_address.user_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("User can't be blank")
      end
      it 'tokenが空では登録できないこと' do
        @order_address.token = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("Token can't be blank")
      end
    end
  end
end
