namespace :send_monthly_incomes_mail do
  task send_monthly_incomes_report: :environment do
    AdminMailer.send_monthly_incomes_report.deliver_now
  end
end
