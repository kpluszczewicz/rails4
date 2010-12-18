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
            Presentation.save_file(@presentation)
            fork do
                pages = 0
                page = 0
                r_pages = Regexp.compile(/Processing pages 1 through (\d+)/)
                dpi = "-r300"
                res = '-dPDFFitPage -g750x1000'
                filename = @presentation.filename.original_filename
                dir = "public/presentations/#{@presentation.id}"
                IO.popen("nice -n 15 gs -dSAFER -dBATCH -dNOPAUSE #{dpi} -dTextAlphaBits=4 -sDEVICE=png16m #{res} -sOutputFile='#{dir}/pres-%00d.png' #{dir}/#{filename}") do |readme|
                readme.each do |line|
                        if pages > 0 #&& line =~ /.+d+.+/
                            page += 1
                        end
                        if r = r_pages.match(line)
                            pages = r[1].to_f()
                            @presentation.pages = pages
                        end
                    end
                    if pages != page
                        @presentation.status = "Error"
                    end
                end
                @presentation.save
            end
        end
        respond_with @presentation
    end
end
