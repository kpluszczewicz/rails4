class Presentation < ActiveRecord::Base
  belongs_to :owner,
    :class_name => "User",
    :foreign_key => "owner_id"
  has_and_belongs_to_many :members,
    :class_name => "User",
    :foreign_key => "presentation_id",
    :association_foreign_key => "user_id"

  # title:string
  # description:text
  # visible:boolean
  # editable:boolean
  # access_key:string
  # content: text

  validates_numericality_of :owner_id,
    :only_integer => true,
    :greater_than => 0,
    :message => I18n.t('activerecord.errors.messages.must_have_owner', :resource_name => Presentation.human_name)
  validates_inclusion_of :visible,
    :in => [true, false]
  validates_inclusion_of :editable,
    :in => [true, false]
  validates_presence_of :access_key
  validates_length_of :access_key,
    :minimum => 4,
    :maximum => 20

  validates :content, :presence => true

  # def self.save_file(upload)
  #   file = upload.filename.original_filename
  #   dir = "public/presentations/#{upload.id}/"
  #   Dir.mkdir(dir) unless File.directory?(dir)
  #   path = File.join(dir, file)
  #   File.open(path, "wb") { |f| f.write(upload.filename.read) }
  # end

  def is_owner?(user)
    return user == owner || new_record?
  end

  def is_visible?(user)
    return true if visible == true || members.exists?(user)
    return is_owner?(user)
  end

  def is_editable?(user)
    return true if editable == true && members.exists?(user)
    return is_owner?(user)
  end

  def is_member?(user)
    return members.exists?(user)
  end
end
