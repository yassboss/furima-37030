require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, :assoc)
    @comment = FactoryBot.create(:comment, user_id: @user.id, item_id: @item.id)
    @notification = FactoryBot.create(:notification, visitor_id: @comment.user_id, visited_id: @item.user_id, item_id: @item.id,
                                                     comment_id: @comment.id)
  end

  describe 'GET #index' do
    it '出品者でログインしてindexアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @item.user
      get notifications_path
      expect(response.status).to eq(200)
    end
    it '出品者でログインしてindexアクションにリクエストするとレスポンスに通知一覧が存在する' do
      sign_in @item.user
      get notifications_path
      expect(response.body).to include('通知一覧')
    end
    it '出品者でログインしてindexアクションにリクエストするとレスポンスにコメントが存在する' do
      sign_in @item.user
      get notifications_path
      expect(response.body).to include(@comment.text)
    end
    it 'コメント者でログインしてindexアクションにリクエストするとレスポンスに通知はありませんの文字が存在する' do
      sign_in @comment.user
      get notifications_path
      expect(response.body).to include('通知はありません')
    end
    it 'ログアウト状態でindexアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      get notifications_path
      expect(response.status).to eq(302)
    end
  end
end
