class BackendController < ApplicationController
  before_filter :set_cache_buster, :only => :colorize

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def colorize
    if request.xhr?
      puts params[:code]
      puts MakersMark::Generator.new(params[:code]).to_html
      render :layout => false, :text => MakersMark::Generator.new(params[:code]).to_html
    end
  end
end
