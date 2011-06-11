require 'generators/coletivo/templates/person_ratings_migration'

ActiveRecord::Schema.define(:version => 1) do
  CreatePersonRatings.up

  create_table :users do |t|
    t.string :name
    t.string :email

    t.timestamps
  end

  create_table :movies do |t|
    t.string :name

    t.timestamps
  end
end
