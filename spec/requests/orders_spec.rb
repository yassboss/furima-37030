require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  before do
    @user = FactoryBot.create(:user, :a)
    @user01 = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, :b)
  end

  describe 'GET #index' do
    it '出品者以外のユーザーでログインしてindexアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user01
      get item_orders_path(@item)
      expect(response.status).to eq(200)
    end
    it 'ログインしていない状態でindexアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      get item_orders_path(@item)
      expect(response.status).to eq(302)
    end
    it 'ログインしていない状態でindexアクションにリクエストするとログイン画面に遷移する' do
      get item_orders_path(@item)
      expect(response).to redirect_to '/users/sign_in'
    end
    it '出品者でログインしてindexアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      sign_in @user
      get item_orders_path(@item)
      expect(response.status).to eq(302)
    end
    it '出品者でログインしてindexアクションにリクエストすると初期画面に遷移する' do
      sign_in @user
      get item_orders_path(@item)
      expect(response).to redirect_to '/'
    end
  end

  describe 'POST #create' do
    it '出品者以外でログインしてcreateアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user01
      post item_orders_path(@item),
           params: { order_address: { token: 'tok_abcdefghijk00000000000000000', postal_code: '123-4567', prefecture_id: 1, city: '札幌市',
                                      house_number: '123', building_name: 'ビル', phone_number: '000000000' } }
      expect(response.status).to eq(200)
    end
    it '出品者でログインしてcreateアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      sign_in @user
      post item_orders_path(@item)
      expect(response.status).to eq(302)
    end
    it 'ログインしていない状態でcreateアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      post item_orders_path(@item)
      expect(response.status).to eq(302)
    end
  end
end
