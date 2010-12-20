class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!, :except => [ :welcome, :aboutus ]

  def after_sign_in_path_for(resource)
    profile_path
  end
end
