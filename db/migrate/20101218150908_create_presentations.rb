class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      t.string :title
      t.text :description
      t.string :filename
      t.string :status, { :default => 'not ready', :null => false }
      t.integer :pages, { :default => 0 }
      t.integer :page, { :default => 0 }

      t.timestamps
    end
  end

  def self.down
    drop_table :presentations
  end
end
