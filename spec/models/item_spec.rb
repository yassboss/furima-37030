require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item, :assoc)
  end

  describe '商品出品の新規登録' do
    context '出品登録できる場合' do
      it '必要項目が全て存在すれば出品登録できる' do
        expect(@item).to be_valid
      end
      it '価格が300〜9999999の範囲であれば出品登録できる' do
        @item.price = 300
        expect(@item).to be_valid
      end
    end
    context '出品登録できない場合' do
      it '商品画像が空では出品登録できない' do
        @item.images = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('画像を入力してください')
      end
      it '商品名が空では出品登録できない' do
        @item.item_name = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('商品名を入力してください')
      end
      it '商品の説明が空では出品登録できない' do
        @item.description = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('商品の説明を入力してください')
      end
      it 'カテゴリー情報が空では出品登録できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('カテゴリーを入力してください')
      end
      it '商品の状態情報が空では出品登録できない' do
        @item.condition_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('商品の状態を入力してください')
      end
      it '配送料の負担情報が空では出品登録できない' do
        @item.shipping_charge_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('配送料の負担を入力してください')
      end
      it '発送元の地域情報が空では出品登録できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('発送元の地域を入力してください')
      end
      it '発送までの日数情報が空では出品登録できない' do
        @item.days_to_ship_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('発送までの日数を入力してください')
      end
      it '価格が空では出品登録できない' do
        @item.price = ''
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格を入力してください')
      end
      it '価格が300〜9999999の範囲になければ出品登録できない(300未満)' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は300以上の値にしてください')
      end
      it '価格が300〜9999999の範囲になければ出品登録できない(10000000以上)' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は9999999以下の値にしてください')
      end
      it '価格が半角数値でなければ出品登録できない' do
        @item.price = '３００'
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は数値で入力してください')
      end
      it '価格が小数を含むと出品登録できない' do
        @item.price = 300.3
        @item.valid?
        expect(@item.errors.full_messages).to include('販売価格は整数で入力してください')
      end
      it 'userが紐付いていないと保存できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('Userを入力してください')
      end
    end
  end
end
