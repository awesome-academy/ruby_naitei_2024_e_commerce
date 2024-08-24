class Api::V1::Admin::BillsController < ApplicationController
  before_action :authenticate_request_api_admin
  before_action :find_bill, only: %i(show update_status)

  def index
    @q = Bill.ransack(params[:q])
    @bills = filter_bills @q

    render json: {
      bills: @bills.as_json(include: {
                              address: {only: Address::PERMITTED_ATTRIBUTES},
                              bill_details: {
                                include: {
                                  product: {only: [:name, :price]}
                                }
                              }
                            })
    }, status: :ok
  end

  def show
    render json: {
      bill: @bill.as_json(include: {
                            address: {only: Address::PERMITTED_ATTRIBUTES},
                            bill_details: {
                              include: {
                                product: {only: [:name, :price]}
                              }
                            }
                          })
    }, status: :ok
  end

  def update_status
    if @bill.update status: params[:status]
      render json: {bill: @bill,
                    message: t("flash.update_successfully")},
             status: :ok
    else
      render json: {errors: @bill.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  private

  def filter_bills q_param
    q_param.result(distinct: true)
           .newest
           .search_by_attributes(params[:search])
           .filter_by_status(params[:statuses])
           .filter_by_voucher(params[:vouchers])
           .filter_by_total_after_discount(params[:from], params[:to])
  end

  def find_bill
    @bill = Bill.find_by(id: params[:id])
    return if @bill

    render json: {error: t("bills.not_found")}, status: :not_found
  end
end
