class Presentation < ActiveRecord::Base
    def self.save_file(upload)
        file = upload.filename.original_filename
        dir = "public/presentations/#{upload.id}/"
        Dir.mkdir(dir) unless File.directory?(dir)
        path = File.join(dir, file)
        File.open(path, "wb") { |f| f.write(upload.filename.read) }
    end
end
