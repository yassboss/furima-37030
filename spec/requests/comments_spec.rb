require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  before do
    @user = FactoryBot.create(:user, :a)
    @item = FactoryBot.create(:item, :a)
  end

  describe 'POST #create' do
    it 'ログイン状態でcreateアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      post item_comments_path(@item), params: { comment: { text: 'test', user_id: 2, item_id: 2 } }
      expect(response).to be_successful
    end
    it 'ログインしていない状態でcreateアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      post item_comments_path(@item)
      expect(response.status).to eq(302)
    end
  end
end
