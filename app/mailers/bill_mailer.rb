class BillMailer < ApplicationMailer
  helper :application
  def bill_info user, bill
    @user = user
    @bill = bill
    @bill_details = @bill.bill_details
    mail to: user.email, subject: t("user_mailer.title")
  end
end
