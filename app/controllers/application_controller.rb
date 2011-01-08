class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :authenticate_user!, :except => [ :welcome, :aboutus, :index ]

  def after_sign_in_path_for(resource)
    profile_path
  end

  def set_locale
    I18n.locale = params[:locale] if params.include?('locale')
  end

  def default_url_options(options = {})
    options.merge!({ :locale => I18n.locale })
  end
end
