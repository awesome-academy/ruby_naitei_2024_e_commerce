class AdminMailer < ApplicationMailer
  helper :application
  def send_monthly_incomes_report
    @incomes_data = Bill.monthly_incomes_report(1.month.ago.beginning_of_month,
                                                1.month.ago.end_of_month)
    mail to: Settings.admin_email, subject: t("admin.cronjob.subject")
  end
end
