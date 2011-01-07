class AddContentToPresentations < ActiveRecord::Migration
  def self.up
    add_column :presentations, :content, :string
  end

  def self.down
    remove_column :presentations, :content
  end
end
