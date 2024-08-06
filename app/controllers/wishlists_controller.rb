class WishlistsController < ApplicationController
  def index
    @wishlists = current_user.wishlists
  end

  def create; end
end
