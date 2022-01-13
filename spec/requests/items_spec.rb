require 'rails_helper'

RSpec.describe 'Items', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, :assoc)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
      get root_path
      expect(response.status).to eq(200)
    end
    it 'indexアクションにリクエストするとレスポンスに出品済みの商品の商品名が存在する' do
      get root_path
      expect(response.body).to include(@item.item_name)
    end
    it 'indexアクションにリクエストするとレスポンスに出品済みの商品の配送料負担が存在する' do
      get root_path
      expect(response.body).to include(@item.shipping_charge.name)
    end
    it 'indexアクションにリクエストするとレスポンスに出品済みの商品の金額が存在する' do
      get root_path
      expect(response.body).to include(@item.price.to_s)
    end
    it 'indexアクションにリクエストするとレスポンスに出品済みの商品の画像が存在する' do
      get root_path
      expect(response.body).to include('test_image.png')
    end
    it 'indexアクションにリクエストするとレスポンスに出品ボタンが存在する' do
      get root_path
      expect(response.body).to include('出品する')
    end
    it 'ログイン状態でindexアクションにリクエストするとレスポンスにユーザーのnicknameが存在する' do
      sign_in @user
      get root_path
      expect(response.body).to include(@user.nickname)
    end
    it 'ログイン状態でindexアクションにリクエストするとレスポンスにログアウトボタンが存在する' do
      sign_in @user
      get root_path
      expect(response.body).to include('ログアウト')
    end
    it 'ログインしていない状態でindexアクションにリクエストするとレスポンスにログインボタンが存在する' do
      get root_path
      expect(response.body).to include('ログイン')
    end
    it 'ログインしていない状態でindexアクションにリクエストするとレスポンスに新規登録ボタンが存在する' do
      get root_path
      expect(response.body).to include('新規登録')
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get item_path(@item)
      expect(response.status).to eq(200)
    end
    it 'showアクションにリクエストするとレスポンスに出品済みの商品の商品名が存在する' do
      get item_path(@item)
      expect(response.body).to include(@item.item_name)
    end
    it 'showアクションにリクエストするとレスポンスに出品済みの商品の画像URLが存在する' do
      get item_path(@item)
      expect(response.body).to include('test_image.png')
    end
    it 'showアクションにリクエストするとレスポンスに出品済みの商品の説明が存在する' do
      get item_path(@item)
      expect(response.body).to include(@item.description)
    end
    it 'showアクションにリクエストするとレスポンスに出品済みの商品の出品者名が存在する' do
      get item_path(@item)
      expect(response.body).to include(@item.user.nickname)
    end
    it 'showアクションにリクエストするとレスポンスにコメント一覧表示部分が存在する' do
      get item_path(@item)
      expect(response.body).to include('コメント一覧')
    end
    it '出品者以外でログインしてshowアクションにリクエストするとレスポンスに購入ボタンが存在する' do
      @another_item = FactoryBot.create(:item, :assoc)
      sign_in @item.user
      get item_path(@another_item)
      expect(response.body).to include('購入')
    end
    it '出品者でログインしてshowアクションにリクエストするとレスポンスに編集ボタンが存在する' do
      sign_in @item.user
      get item_path(@item)
      expect(response.body).to include('編集')
    end
    it '出品者でログインしてshowアクションにリクエストするとレスポンスに削除ボタンが存在する' do
      sign_in @item.user
      get item_path(@item)
      expect(response.body).to include('削除')
    end
    it 'showアクションにリクエストするとレスポンスにコメントフォームが存在する' do
      sign_in @user
      get item_path(@item)
      expect(response.body).to include('コメントする')
    end
  end

  describe 'GET #new' do
    it 'ログイン状態でnewアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      get new_item_path
      expect(response.status).to eq(200)
    end
    it 'ログイン状態でnewアクションにリクエストするとレスポンスに商品の情報を入力する部分が存在する' do
      sign_in @user
      get new_item_path
      expect(response.body).to include('商品の情報を入力')
    end
    it 'ログインしていない状態でnewアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      get new_item_path
      expect(response.status).to eq(302)
    end
    it 'ログインしていない状態でnewアクションにリクエストするとログイン画面に遷移する' do
      get new_item_path
      expect(response).to redirect_to '/users/sign_in'
    end
  end

  describe 'POST #create' do
    it 'ログイン状態でcreateアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      post items_path,
           params: { item: { item_name: 'test', description: 'test', category_id: 1, condition_id: 1, shipping_charge_id: 1,
                             prefecture_id: 1, days_to_ship_id: 1, price: 2000, user_id: @user.id } }
      expect(response.status).to eq(200)
    end
    it 'ログインしていない状態でcreateアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      post items_path
      expect(response.status).to eq(302)
    end
  end

  describe 'GET #edit' do
    it '出品者でログインしてeditアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @item.user
      get edit_item_path(@item)
      expect(response.status).to eq(200)
    end
    it '出品者でログインしてeditアクションにリクエストするとレスポンスに商品の情報を入力する部分が存在する' do
      sign_in @item.user
      get edit_item_path(@item)
      expect(response.body).to include('商品の情報を入力')
    end
    it 'ログインしていない状態でeditアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      get edit_item_path(@item)
      expect(response.status).to eq(302)
    end
    it 'ログインしていない状態でeditアクションにリクエストするとログイン画面に遷移する' do
      get edit_item_path(@item)
      expect(response).to redirect_to '/users/sign_in'
    end
  end

  describe 'POST #update' do
    it '出品者でログインしてupdateアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @item.user
      post items_path(@item),
           params: { item: { item_name: 'test', description: 'test', category_id: 1, condition_id: 1, shipping_charge_id: 1,
                             prefecture_id: 1, days_to_ship_id: 1, price: 2000, user_id: @item.user.id } }
      expect(response.status).to eq(200)
    end
    it 'ログインしていない状態でupdateアクションにリクエストするとレスポンスにステータスコード401が返ってくる' do
      post items_path(@item)
      expect(response.status).to eq(401)
    end
  end
end
