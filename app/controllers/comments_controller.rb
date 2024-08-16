class CommentsController < ApplicationController
  before_action :check, only: :new
  before_action :authenticate_user!
  def new
    @comment = Comment.new
    @comments = @product.comments
  end

  def create
    @comment = Comment.new comment_params

    if @comment.save
      flash[:success] = t "flash.create_successfully"
      redirect_to bills_path, status: :see_other
    else
      flash.now[:danger] = t "flash.create_unsuccessfully"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(Comment::PERMITTED_ATTRIBUTES)
  end

  def check
    @bill_detail_id = params[:bill_detail_id]
    @product =
      Product.includes(comments: :user).find_by(id: params[:product_id])
    if @product.nil?
      flash[:alert] = t "errors.product.not_found"
      redirect_to root_path and return
    elsif check_exists?
      flash[:alert] = t "errors.comment.has_commented"
      redirect_to root_path and return
    end
  end

  def check_exists?
    Comment.exists?(user_id: current_user.id,
                    bill_detail_id: @bill_detail_id, product_id: @product.id)
  end

  def load_product; end
end
