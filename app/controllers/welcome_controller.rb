class WelcomeController < ApplicationController
  def welcome
  end

  def profile
    @user = current_user
    @presentations = current_user.presentations
    @subscribe = current_user.member_of
  end

  def aboutus
  end
end
