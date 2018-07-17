class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t "account_active"
  end
end
