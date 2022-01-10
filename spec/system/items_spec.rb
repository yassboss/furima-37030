require 'rails_helper'

RSpec.describe '商品出品', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, :a)
  end
  context '商品出品ができるとき' do
    it 'ログインしたユーザーは商品出品できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      # 新規出品ページへのボタンがあることを確認する
      expect(page).to have_content('出品する')
      # 出品ページに移動する
      visit new_item_path
      # フォームに情報を入力する
      attach_file 'item[image]', 'public/images/test_image.png', make_visible: true
      fill_in 'item-name', with: @item.item_name
      fill_in 'item-info', with: @item.description
      select 'レディース', from: 'item-category'
      select '未使用に近い', from: 'item-sales-status'
      select '着払い(購入者負担)', from: 'item-shipping-fee-status'
      select '北海道', from: 'item-prefecture'
      select '2~3日で発送', from: 'item-scheduled-delivery'
      fill_in 'item-price', with: @item.price
      # 送信するとItemモデルのカウントが1上がることを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { Item.count }.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # 出品した商品が表示されていることを確認する
      expect(page).to have_content(@item.item_name)
      # トップページには先ほど出品した商品が存在することを確認する（画像）
      expect(page).to have_selector "img[src$='test_image.png']"
      # トップページには先ほど出品した商品が存在することを確認する（商品名）
      expect(page).to have_content(@item.item_name)
      # トップページには先ほど出品した商品が存在することを確認する（配送料負担）
      expect(page).to have_content(@item.shipping_charge.name)
    end
  end
  context '商品が出品できないとき' do
    it 'ログインしていないと出品ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 出品ページにリクエストするとログインページへ戻されることを確認する
      visit new_item_path
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe '商品編集', type: :system do
  before do
    @item01 = FactoryBot.create(:item, :a)
    @item02 = FactoryBot.create(:item, :a)
  end
  context '商品編集ができるとき' do
    it 'ログインしたユーザーは自分が出品した商品の編集ができる' do
      # 商品01を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'email', with: @item01.user.email
      fill_in 'password', with: @item01.user.password
      find('input[name="commit"]').click
      # 商品01の詳細ページに遷移する
      visit item_path(@item01)
      # 商品01に「編集」へのリンクがあることを確認する
      expect(page).to have_content('商品の編集')
      # 編集ページへ遷移する
      visit edit_item_path(@item01)
      # すでに出品済みの内容がフォームに入っていることを確認する
      expect(page).to have_selector('img')
      expect(page).to have_content(@item01.item_name)
      expect(page).to have_content(@item01.shipping_charge.name)
      expect(find('#item-price').value).to eq(@item01.price.to_s)
      expect(page).to have_content(@item01.description)
      expect(page).to have_content(@item01.category.name)
      expect(page).to have_content(@item01.condition.name)
      expect(page).to have_content(@item01.prefecture.name)
      expect(page).to have_content(@item01.days_to_ship.name)
      # 商品内容を編集する
      fill_in 'item-name', with: '編集した商品名'
      # 編集してもItemモデルのカウントは変わらないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { Item.count }.by(0)
      # 商品詳細ページに遷移することを確認する
      expect(current_path).to eq(item_path(@item01))
      # 商品詳細ページには先ほど変更した内容の商品が存在することを確認する（商品名）
      expect(page).to have_content('編集した商品名')
    end
  end
  context '商品編集ができないとき' do
    it 'ログインしたユーザーは自分以外が商品したツイートの編集画面には遷移できない' do
      # 商品01を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'email', with: @item01.user.email
      fill_in 'password', with: @item01.user.password
      find('input[name="commit"]').click
      # 商品02に「編集」へのリンクがないことを確認する
      visit item_path(@item02)
      expect(page).to have_no_content('商品の編集')
    end
    it 'ログインしていないと商品の編集画面には遷移できない' do
      # 商品01の商品詳細ページにいる
      visit item_path(@item01)
      # 商品01に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('商品の編集')
      # 商品02の商品詳細ページにいる
      visit item_path(@item02)
      # 商品02に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('商品の編集')
    end
  end
end

RSpec.describe '商品削除', type: :system do
  before do
    @item01 = FactoryBot.create(:item, :a)
    @item02 = FactoryBot.create(:item, :a)
  end
  context '商品削除ができるとき' do
    it 'ログインしたユーザーは自らが出品した商品の削除ができる' do
      # 商品01を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'email', with: @item01.user.email
      fill_in 'password', with: @item01.user.password
      find('input[name="commit"]').click
      # 商品01に「削除」へのリンクがあることを確認する
      visit item_path(@item01)
      expect(page).to have_content('削除')
      # 商品を削除するとレコードの数が1減ることを確認する
      expect do
        find_link('削除', href: item_path(@item01)).click
      end.to change { Item.count }.by(-1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # トップページには商品01の内容が存在しないことを確認する（画像）
      expect(page).to have_no_content('test_image.png')
      # トップページには商品01の内容が存在しないことを確認する（商品名）
      expect(page).to have_no_content(@item01.item_name)
    end
  end
  context '商品削除ができないとき' do
    it 'ログインしたユーザーは自分以外が出品した商品の削除ができない' do
      # 商品01を出品したユーザーでログインする
      visit new_user_session_path
      fill_in 'email', with: @item01.user.email
      fill_in 'password', with: @item01.user.password
      find('input[name="commit"]').click
      # 商品02に「削除」へのリンクがないことを確認する
      visit item_path(@item02)
      expect(page).to have_no_content('削除')
    end
    it 'ログインしていないと商品の削除ボタンがない' do
      # 商品01に「削除」へのリンクがないことを確認する
      visit item_path(@item01)
      expect(page).to have_no_content('削除')
      # 商品02に「削除」へのリンクがないことを確認する
      visit item_path(@item02)
      expect(page).to have_no_content('削除')
    end
  end
end
