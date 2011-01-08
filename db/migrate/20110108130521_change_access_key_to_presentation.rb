class ChangeAccessKeyToPresentation < ActiveRecord::Migration
  def self.up
    change_column :presentations, :access_key, :string, :null => false, :default => ''
  end

  def self.down
    change_column :presentations, :access_key, :string, :null => false, :default => '1234'
  end
end
