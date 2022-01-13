require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, :assoc)
    @comment = FactoryBot.build(:comment, user_id: @user.id, item_id: @item.id)
  end

  describe 'POST #create' do
    it 'ログイン状態でcreateアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @user
      post item_comments_path(@item),
           params: { comment: { text: @comment.text, user_id: @comment.user_id, item_id: @comment.item_id } }
      expect(response).to be_successful
    end
    it 'ログインしていない状態でcreateアクションにリクエストするとレスポンスにステータスコード302が返ってくる' do
      post item_comments_path(@item)
      expect(response.status).to eq(302)
    end
  end
end
