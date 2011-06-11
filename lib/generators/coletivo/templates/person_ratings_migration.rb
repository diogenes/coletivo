class CreatePersonRatings < ActiveRecord::Migration
  def self.up
    create_table :person_ratings do |t|
      t.integer :person_id
      t.string  :person_type

      t.integer :rateable_id
      t.string  :rateable_type

      t.decimal :weight, :precision => 5, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :person_ratings
  end
end
