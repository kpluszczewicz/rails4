class PresentationsController < ApplicationController
  before_filter :presentation_not_found, :except => [ :index, :new, :create, :index_public, :index_private ]
  before_filter :presentation_visible, :only => [ :show, :run ]
  before_filter :presentation_editable, :only => [ :edit, :update ]
  before_filter :presentation_destroy, :only => [ :destroy ]
  before_filter :only => [:index, :tags] do
    @tags = Presentation.tag_counts
  end

  load_and_authorize_resource

  # note:
  # instancja '@presentation = Presentation.find(params[:id])' dla akcji poza
  # 'index, new, create' znajduje sie w metodzie 'presentation_not_found'

  def index
    #@user = current_user
    #@presentations = @user.presentations
    #if current_user
    query = params[:search]
    @presentations = Presentation.where("(title like ? or description like ?) and visible = ?", "%#{query}%", "%#{query}%", true)
    @tags = Presentation.tag_counts
  end

  def tags
    @fortunes = Presentation.tagged_with(params[:name])
    render 'index'
  end

  def show
    @user = current_user
  end

  def index_private
    @presentations = Presentation.paginate :page => params[:page], :conditions => ['visible = ?', true]
    render 'index_private'
  end

  def index_public
    @presentations = Presentation.paginate :page => params[:page], :conditions => ['visible = ?', true]
    render 'index_public'
  end

  def new
    @user = current_user
    @presentation = Presentation.new
  end

  def create
    @user = current_user
    @presentation = @user.presentations.build(params[:presentation])
    if @presentation.save
      flash[:notice] = t('flash.actions.create.notice', :resource_name => Presentation.human_name)
      redirect_to profile_path
    else
      render 'new'
    end
  end

  def update
    if @presentation.update_attributes(params[:presentation])
      flash[:notice] = t('flash.actions.update.notice', :resource_name => Presentation.human_name)
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  def destroy
    @presentation.destroy
    flash[:notice] = t('flash.actions.destroy.notice', :resource_name => Presentation.human_name)
    redirect_to profile_path
  end

  def edit
    @user = current_user
  end

  def colorize
    
  end

  #TODO
  def subscribe

  end

  def subscribe_create
    if params.has_key?(:access_key) && @presentation.access_key == params[:access_key]
      current_user.member_of << @presentation
      flash[:notice] = t('flash.actions.subscribe.create.notice')
      redirect_to profile_path
    else
      flash[:alert] = t('flash.actions.subscribe.create.alert')
      render 'subscribe'
    end
  end

  def subscribe_destroy
    current_user.member_of.delete(@presentation)
    flash[:notice] = t('flash.actions.subscribe.destroy.notice')
    redirect_to profile_path
  end

  def run
    @content = @presentation.content.gsub("\r","")

    @raw = @content =~ /\A!SLIDE/ ? @content : "!SLIDE\n#{@content}"
    @slides = slides
    @additionals = "shared/slides"
    @presentation_id = params[:id]
    render :layout => 'presentation'
  end

  def watch
    @slide_box = Slide.new('')
    @slides = [ @slide_box ]
    @additionals = "shared/faye_sub"
    @presentation_id = params[:id]
    render :layout => 'presentation'
  end


  private

  def presentation_not_found
    begin
      @presentation = Presentation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = t('flash.before.not_found', :resource_name => Presentation.human_name)
      redirect_to(presentations_path)
      return false
    end
    return true
  end

  def presentation_visible
    return true if @presentation.is_visible?(current_user)
    flash[:warning] = t('flash.before.subscribe', :resource_name => Presentation.human_name.downcase)
    redirect_to(subscribe_path)
    return false
  end

  def presentation_editable
    if !@presentation.is_owner?(current_user) && params.has_key?(:presentation)
      params[:presentation].delete(:visible) if params[:presentation].has_key?(:visible)
      params[:presentation].delete(:editable) if params[:presentation].has_key?(:editable)
      params[:presentation].delete(:access_key) if params[:presentation].has_key?(:access_key)
    end
    return true if @presentation.is_editable?(current_user)
    flash[:alert] = t('flash.before.access_denied')
    redirect_to(presentations_path)
    return false
  end

  def presentation_destroy
    return true if @presentation.is_owner?(current_user)
    flash[:alert] = t('flash.before.access_denied')
    redirect_to(presentations_path)
    return false
  end

  def slides
    @slides ||= lines.map { |text| Slide.new(text) }
  end

  def lines
    @lines ||= @content.split(/^!SLIDE\s*([a-z\s]*)$/).reject { |line| line.empty? }
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
