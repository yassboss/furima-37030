require 'rails_helper'

RSpec.describe 'コメント投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, :assoc)
  end
  context 'コメントができるとき' do
    it 'ログインしたユーザーはコメントできる' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      # 商品詳細ページに遷移する
      visit item_path(@item)
      # コメントフォームが表示されていることを確認する
      expect(page).to have_content('コメントする')
      # フォームに情報を入力する
      fill_in 'comment_text', with: 'test_comment!'
      # 送信するとCommentモデルとNotificationモデルのカウントが1上がることを確認する
      expect do
        find('button[name="button"]').click
      end.to change { Comment.count }.by(1), change { Notification.count }.by(1)
      # 入力したコメントが表示されていることを確認する
      expect(page).to have_content('test_comment!')
    end
  end
  context 'コメントができないとき' do
    it 'ログインしていないユーザーはコメントできない' do
      # 商品詳細ページに遷移する
      visit item_path(@item)
      # コメントフォームが表示されていないことを確認する
      expect(page).to have_no_content('コメントする')
    end
  end
end

RSpec.describe 'コメント削除', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, :assoc)
    @comment = FactoryBot.create(:comment, :assoc_user, item_id: @item.id)
  end
  context 'コメントが削除できるとき' do
    it '出品者ユーザーはコメントを削除できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @item.user.email
      fill_in 'password', with: @item.user.password
      find('input[name="commit"]').click
      # 商品詳細ページに遷移する
      visit item_path(@comment.item)
      # コメント削除ボタンが表示されていることを確認する
      expect(page).to have_selector('#comment-destroy')
      # 削除ボタンを押すとCommentモデルのカウントが1下がることを確認する
      expect do
        page.find('svg[id="comment-destroy-btn"]').click
      end.to change { Comment.count }.by(-1)
      # 削除したコメントが表示されていないことを確認する
      expect(page).to have_no_content(@comment.text)
    end
  end
  context 'コメントが削除できないとき' do
    it '出品者ユーザー以外はコメントを削除できない' do
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      # 商品詳細ページに遷移する
      visit item_path(@comment.item)
      # コメント削除ボタンが表示されないことを確認する
      expect(page).to have_no_selector('#comment-destroy')
    end
  end
end
