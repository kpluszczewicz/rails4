class WelcomeController < ApplicationController
  def welcome
  end

  def profile
    raise CanCan::AccessDenied if current_user.nil? || current_user.email.empty?

    @user = current_user
    @presentations = current_user.presentations
    @subscribe = current_user.member_of
  end

  def aboutus
  end
end
