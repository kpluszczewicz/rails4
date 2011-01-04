class WelcomeController < ApplicationController
  respond_to :html

  def welcome
  end

  def profile
    @presentations = current_user.presentations
    @member_of = current_user.member_of

    respond_with(@presentations, @member_of)
  end

  def aboutus
  end
end
