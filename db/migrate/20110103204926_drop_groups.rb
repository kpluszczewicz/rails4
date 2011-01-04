class DropGroups < ActiveRecord::Migration
  def self.up
    drop_table :groups
  end

  def self.down
    create_table :groups do |t|
      t.string :name, :null => false, :unique => true
      t.boolean :visible, :null => false, :default => true
      t.boolean :editable, :null => false, :default => false
      t.references :owner, :null => false

      t.timestamps
    end
  end
end
