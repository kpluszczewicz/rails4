class DropGroupsUsers < ActiveRecord::Migration
  def self.up
    drop_table :groups_users
  end

  def self.down
    create_table :groups_users, :id => false do |t|
      t.references :group, :null => false
      t.references :user, :null => false

      t.timestamps
    end
  end
end
