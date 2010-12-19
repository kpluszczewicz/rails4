class PresentationsController < ApplicationController
    respond_to :html, :js

    def new
        @presentation = Presentation.new
        respond_with @presentation
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

    def show
        @presentation = Presentation.find(params[:id])
        @progress = (@presentation.page.to_f() / @presentation.pages.to_f() * 100.0)
    end
end
