class User < ActiveRecord::Base
  has_many :presentations,
    :dependent => :destroy,
    :class_name => "Presentation",
    :foreign_key => "owner_id"
  has_and_belongs_to_many :member_of,
    :class_name => "Presentation",
    :foreign_key => "user_id",
    :association_foreign_key => "presentation_id"

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_and_belongs_to_many :roles

  def role?(role)
    roles.include? role.to_s
  end
end
