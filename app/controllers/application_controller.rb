class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options options = {}
    logger.debug "default_url_options is passed options:
    #{options.inspect}\n"
    {locale: I18n.locale}
  end
end
