require 'rails_helper'

RSpec.describe '商品購入', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, user_id: @user.id)
  end
  context '商品購入ができるとき' do
    it '出品者でないユーザーでログインして商品が販売中なら商品を購入できる' do
      # 出品者でないユーザーでログインする
      visit new_user_session_path
      fill_in 'email', with: @another_user.email
      fill_in 'password', with: @another_user.password
      find('input[name="commit"]').click
      # 購入画面に遷移する
      visit item_orders_path(@item)
      # フォームに情報を入力する
      fill_in 'card-number', with: '4242424242424242'
      fill_in 'card-exp-month', with: '10'
      fill_in 'card-exp-year', with: '22'
      fill_in 'card-cvc', with: '123'
      fill_in 'postal-code', with: '123-4567'
      select '北海道', from: 'prefecture'
      fill_in 'city', with: '横浜市緑区'
      fill_in 'addresses', with: '青山１-１-１'
      fill_in 'building', with: '柳ビル'
      fill_in 'phone-number', with: '09012345678'
      # 購入ボタンを押す
      find('input[name="commit"]').click
      sleep 0.5
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # 購入した商品にSold Out!!の表示があることを確認する
      expect(page).to have_content('Sold Out!!')
    end
  end
  context '商品購入ができないとき' do
    it 'ログインしていない状態では商品を購入できない' do
      # 商品詳細ページに遷移する
      visit item_path(@item)
      # 購入ボタンが存在しないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # 商品購入ページにリクエストする
      visit item_orders_path(@item)
      # ログイン画面に遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it '販売中商品であっても出品者ユーザーなら商品を購入できない' do
      # 出品者ユーザーでログインする
      visit new_user_session_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      # 商品詳細ページに遷移する
      visit item_path(@item)
      # 購入ボタンが存在しないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # 商品購入画面にリクエストする
      visit item_orders_path(@item)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
    end
    it '出品者でないユーザーでログインしても売却済商品なら商品を購入できない' do
      @order = FactoryBot.create(:order, item_id: @item.id)
      # 出品者でないユーザーでログインする
      visit new_user_session_path
      fill_in 'email', with: @another_user.email
      fill_in 'password', with: @another_user.password
      find('input[name="commit"]').click
      # 商品詳細ページに遷移する
      visit item_path(@item)
      # 購入ボタンが存在しないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # 商品購入画面にリダイレクトする
      visit item_orders_path(@item)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
    end
  end
end
