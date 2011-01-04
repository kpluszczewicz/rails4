class CreatePresentationsUsers < ActiveRecord::Migration
  def self.up
    create_table :presentations_users, :id => false do |t|
      t.references :user, :null => false
      t.references :presentation, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :presentations_users
  end
end
