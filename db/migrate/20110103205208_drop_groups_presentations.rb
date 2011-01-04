class DropGroupsPresentations < ActiveRecord::Migration
  def self.up
    drop_table :groups_presentations
  end

  def self.down
    create_table :groups_presentations, :id => false do |t|
      t.references :group, :null => false
      t.references :presentation, :null => false

      t.timestamps
    end
  end
end
