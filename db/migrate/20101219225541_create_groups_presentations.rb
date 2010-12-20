class CreateGroupsPresentations < ActiveRecord::Migration
  def self.up
    create_table :groups_presentations, :id => false do |t|
      t.references :group, :null => false
      t.references :presentation, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :groups_presentations
  end
end
