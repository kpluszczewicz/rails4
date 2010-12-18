class PresentationsController < ApplicationController
    respond_to :html, :js

    def new
        @presentation = Presentation.new
        respond_with @presentation
    end

    def save

    end
end
