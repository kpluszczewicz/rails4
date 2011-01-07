class PresentationsController < ApplicationController
  respond_to :html, :js

  def index
    @presentations = Presentation.all
    respond_with(@presentations)
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
    #TODO
    @progress = (@presentation.page.to_f() / @presentation.pages.to_f() * 100.0)
    respond_with(@presentation, @progress)
  end

  def new
    @presentation = Presentation.new
    @user = current_user
    respond_with(@presentation)
  end

  def create
    @presentation = Presentation.new(params[:presentation])
    if @presentation.save
      puts @presentation
      if @presentation.filename
        Presentation.save_file(@presentation)
        fork do
          pages = 0
          page = 0
          r_pages = Regexp.compile(/Processing pages 1 through (\d+)/)
          dpi = "-r300"
          res = '-dPDFFitPage -g750x1000'
          filename = @presentation.filename.original_filename
          dir = "public/presentations/#{@presentation.id}"
          @presentation.status = 'Processing'
          IO.popen("nice -n 15 gs -dSAFER -dBATCH -dNOPAUSE #{dpi} -dTextAlphaBits=4 -sDEVICE=png16m #{res} -sOutputFile='#{dir}/pres-%00d.png' #{dir}/#{filename}") do |readme|
            readme.each do |line|
              if pages > 0 #&& line =~ /.+d+.+/
                page += 1
                @presentation.page = page
              end
              if r = r_pages.match(line)
                pages = r[1].to_f()
                @presentation.pages = pages
              end
              @presentation.save
            end
            if pages != page
              @presentation.status = "Error"
            else
              @presentation.status = "Ready"
            end
            @presentation.save
          end
        end # fork do
      end # if @presentation.filename
    end # if @presentation.save
    respond_with @presentation
  end

  def edit
    begin
      @presentation = Presentation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      not_found
      return
    end
    if !@presentation.is_editable?(current_user)
      flash[:warning] = "No permission to edit the presentation"
      redirect_to(presentations_path(@presentation))
      return
    end
    #TODO
  end

  def update
    #TODO
  end

  #TODO
  def access

  end

  def access_create

  end

  def access_destroy

  end

  def run
    @raw = @content =~ /\A!SLIDE/ ? @content : "!SLIDE\n#{@content}"
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
