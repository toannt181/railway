class SendEmailJob < ApplicationJob
  queue_as :default

  def perform user
    @user = user
    UserMailer.account_activation(@user).deliver_later
  end
end
