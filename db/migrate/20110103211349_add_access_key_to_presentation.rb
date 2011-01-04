class AddAccessKeyToPresentation < ActiveRecord::Migration
  def self.up
    add_column :presentations, :access_key, :string, :null => false, :default => '1234'
  end

  def self.down
    remove_column :presentations, :access_key
  end
end
