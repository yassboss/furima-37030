require 'rails_helper'

RSpec.describe '通知', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, :a)
    @comment = FactoryBot.create(:comment, user_id: @user.id, item_id: @item.id)
    @notification = FactoryBot.create(:notification, visitor_id: @comment.user_id, visited_id: @item.user_id, item_id: @item.id,
                                                     comment_id: @comment.id)
  end
  context '通知確認' do
    it '出品者以外のユーザーがコメントすると通知が作成され出品者が確認できる' do
      # 出品者ユーザーでログインする
      visit new_user_session_path
      fill_in 'email', with: @item.user.email
      fill_in 'password', with: @item.user.password
      find('input[name="commit"]').click
      # トップページにコメントの通知マークがあることを確認する
      expect(page).to have_selector('.fa-bell')
      # トップページのコメントボタンを押すとコメントリストが表示されることを確認する
      find('#comment-letter').click
      expect(page).to have_content(@comment.text)
      # コメントリストの「コメントを全て表示」をクリックすると通知一覧ページに遷移することを確認する
      find_link('コメントを全て表示', href: '/notifications').click
      expect(current_path).to eq(notifications_path)
      # コメント一覧ページにコメント者名と商品名が表示されていることを確認する
      expect(page).to have_content(@comment.user.nickname)
      expect(page).to have_content(@item.item_name)
      # コメントの商品名をクリックすると商品詳細ページに遷移することを確認する
      find_link(@item.item_name.to_s).click
      expect(current_path).to eq(item_path(@item))
    end
  end
end
