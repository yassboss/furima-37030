require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment, :assoc)
  end

  describe 'コメント投稿' do
    context 'コメント投稿ができる場合' do
      it '必要項目が全て存在すれば投稿できる' do
        expect(@comment).to be_valid
      end
    end
    context 'コメント投稿ができない場合' do
      it 'textが空では投稿できない' do
        @comment.text = ''
        @comment.valid?
        expect(@comment.errors.full_messages).to include('コメント内容を入力してください')
      end
      it 'ユーザーが紐付いていなければ投稿できない' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Userを入力してください')
      end
      it '商品が紐付いていなければ投稿できない' do
        @comment.item = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Itemを入力してください')
      end
    end
  end
end
