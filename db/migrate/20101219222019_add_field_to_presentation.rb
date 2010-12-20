class AddFieldToPresentation < ActiveRecord::Migration
  def self.up
    add_column :presentations, :visible, :boolean, :null => false, :default => true
    add_column :presentations, :editable, :boolean, :null => false, :default => false
    add_column :presentations, :owner_id, :integer, :null => false, :default => false
  end

  def self.down
    remove_column :presentations, :owner_id
    remove_column :presentations, :editable
    remove_column :presentations, :visible
  end
end
