class PresentationsController < ApplicationController
  def index
    @user = current_user
    @presentations = @user.presentations 
  end

  def show
    begin
      @presentation = Presentation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      not_found
      return
    end
    if !@presentation.is_visible?(current_user)
      redirect_to(access_path)
      return
    end
    @progress = (@presentation.page.to_f() / @presentation.pages.to_f() * 100.0)
    respond_with(@presentation, @progress)
  end

  def new
    @presentation = Presentation.new
  end

  def create
    @user = current_user
    @presentation = @user.presentations.build(params[:presentation]) 

    if @presentation.save
      flash[:success] = t('flash.actions.create.notice', :resource_name => Presentation.human_name)
      redirect_to profile_path
    else
      render 'new' 
    end
  end

  def update
    @presentation = Presentation.find(params[:id])
    if @presentation.update_attributes(params[:presentation])
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  def destroy
    @presentation = Presentation.find(params[:id])
    @presentation.destroy
    flash[:success] = t('flash.actions.destroy.notice', :resource_name => Presentation.human_name)
    redirect_to profile_path
  end

  def edit
    @presentation = Presentation.find(params[:id])
  end

  #TODO
  def access

  end

  def access_create

  end

  def access_destroy

  end

  def run
    @presentation = Presentation.find(params[:id]) 
    @content = @presentation.content.gsub("\r","")

    @raw = @content =~ /\A!SLIDE/ ? @content : "!SLIDE\n#{@content}"
    @slides = slides
    render :layout => 'presentation'
  end

  private

  def not_found
    flash[:alert] = "Presentation was not found"
    redirect_to(presentations_path)
  end

  def slides
    @slides ||= lines.map { |text| Slide.new(text) }
  end

  def lines
    @lines ||= @content.split(/^!SLIDE\s*([a-z\s]*)$/).reject { |line| line.empty? }
    puts @lines
    @lines.each { |e| puts "LINIA: " + e }
  end

  class Slide
    attr_accessor :text, :classes, :notes

    def initialize(text, *classes)
      @text    = text
      @classes = classes
      @notes   = nil

      extract_notes!
    end

    def html
      MakersMark::Generator.new(@text).to_html
    end

    private

    def extract_notes!
      @text.gsub!(/^!NOTES\s*(.*\n)$/m) do |note|
        @notes = note.to_s.chomp.gsub('!NOTES', '')
        ''
      end
    end
  end

end
