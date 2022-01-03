class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :move_to_root_path, only: [:destroy]

  def create
    @comment = Comment.new(comment_params)
    @item = Item.find(params[:item_id])
    if @comment.save
      CommentChannel.broadcast_to @item, {comment: @comment, user: @comment.user, item: @item}
    end
  end

  def destroy
    @comment = Comment.find(params[:item_id])
    @comment.destroy
    redirect_to "/items/#{params[:id]}"
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, item_id: params[:item_id])
  end

  def move_to_root_path
    @item = Item.find(params[:id])
    redirect_to root_path unless current_user.id == @item.user_id
  end
end
