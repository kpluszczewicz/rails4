class Presentation < ActiveRecord::Base
  belongs_to :owner,
    :class_name => "User",
    :foreign_key => "owner_id"
  has_and_belongs_to_many :groups

  # title:string
  # description:text
  # visible:boolean
  # editable:boolean

    def self.save_file(upload)
        file = upload.filename.original_filename
        dir = "public/presentations/#{upload.id}/"
        Dir.mkdir(dir) unless File.directory?(dir)
        path = File.join(dir, file)
        File.open(path, "wb") { |f| f.write(upload.filename.read) }
    end
end
