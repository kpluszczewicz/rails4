class Presentation < ActiveRecord::Base
  cattr_reader    :per_page
  @@per_page = 10

  acts_as_taggable_on :tags
  ActsAsTaggableOn::TagList.delimiter = " "

  belongs_to :owner,
    :class_name => "User",
    :foreign_key => "owner_id"
  has_and_belongs_to_many :members,
    :class_name => "User",
    :foreign_key => "presentation_id",
    :association_foreign_key => "user_id"
  has_many :comments, :dependent => :destroy

  validates_numericality_of :owner_id,
    :only_integer => true,
    :greater_than => 0,
    :message => I18n.t('activerecord.errors.messages.must_have_owner', :resource_name => Presentation.human_name)
  validates_inclusion_of :visible,
    :in => [true, false]
  validates_inclusion_of :editable,
    :in => [true, false]

  validates :access_key, :presence => { :unless => 'visible', :value => true }, :length => { :unless => 'visible', :value => true, :minimum => 4, :maximum => 20 }
  validates :content, :presence => true

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

  def self.search(query)
    where("title like ?", "%#{query}%")
  end
end
