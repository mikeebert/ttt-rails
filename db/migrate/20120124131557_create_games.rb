class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.text :grid
      t.timestamps
    end
  end
end
