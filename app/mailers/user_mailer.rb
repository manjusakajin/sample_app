class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("account_active")
  end

  def reset_password user
    @user = user
    mail to: user.email, subject: t("reset_pass")
  end
end
