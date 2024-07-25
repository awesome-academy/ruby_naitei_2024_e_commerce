class BillsController < ApplicationController
  before_action :logged_in_user, :load_current_user_cart
  def new
    @bill = Bill.new
  end
end
