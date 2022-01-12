require 'rails_helper'

RSpec.describe Notification, type: :model do
  before do
    @item = FactoryBot.build(:item, :a) 
    @comment = FactoryBot.build(:comment, :a)
  end

  describe 'コメント投稿の通知' do
    context '通知が登録できる場合' do
      it 'コメント投稿すると通知が登録がされる' do
        @notification = FactoryBot.build(:notification, item_id: @item.id, comment_id: @comment.id)
        expect(@notification).to be_valid
      end
    end
  end
end
