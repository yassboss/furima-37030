require 'rails_helper'

RSpec.describe OrderAddress, type: :model do
  describe '配送先の登録' do
    before do
      user = FactoryBot.create(:user)
      item = FactoryBot.create(:item, :assoc)
      @order_address = FactoryBot.build(:order_address, item_id: item.id, user_id: user.id)
      sleep 0.5
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
        expect(@order_address.errors.full_messages).to include('郵便番号を入力してください')
      end
      it '郵便番号が「3桁ハイフン4桁」の半角文字列でなければ登録できない' do
        @order_address.postal_code = '1234567'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('郵便番号は次のように入力してください(例: 123-4567)')
      end
      it '都道府県が空では登録できない' do
        @order_address.prefecture_id = 1
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('都道府県を入力してください')
      end
      it '市区町村が空では登録できない' do
        @order_address.city = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('市区町村を入力してください')
      end
      it '番地が空では登録できない' do
        @order_address.house_number = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('番地を入力してください')
      end
      it '電話番号が空では登録できない' do
        @order_address.phone_number = ''
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号を入力してください')
      end
      it '電話番号が10桁未満では登録できない' do
        @order_address.phone_number = '123456789'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号は10文字以上で入力してください')
      end
      it '電話番号が12桁以上では登録できない' do
        @order_address.phone_number = '123456789123'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号は11文字以内で入力してください')
      end
      it '電話番号に数字以外が含まれていれば登録できない' do
        @order_address.phone_number = '123-4567-89'
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('電話番号は数値で入力してください')
      end
      it 'itemが紐づいていないと保存できない' do
        @order_address.item_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('Itemを入力してください')
      end
      it 'userが紐づいていないと保存できない' do
        @order_address.user_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('Userを入力してください')
      end
      it 'tokenが空では登録できないこと' do
        @order_address.token = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include('クレジットカード情報を入力してください')
      end
    end
  end
end
