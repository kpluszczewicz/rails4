class Group < ActiveRecord::Base
  belongs_to :owner,
    :class_name => "User",
    :foreign_key => "owner_id"
  has_and_belongs_to_many :members,
    :class_name => "User",
    :foreign_key => "group_id",
    :association_foreign_key => "user_id"
  has_and_belongs_to_many :presentations

  # name:string
  # visible:boolean
  # editable:boolean
end
