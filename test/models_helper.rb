require 'coletivo'

class User < ActiveRecord::Base
  has_own_preferences
end

class Movie < ActiveRecord::Base
  acts_as_rateable
end

class Actor < ActiveRecord::Base
  acts_as_rateable
end

def ratings_container
  Coletivo::Config.ratings_container
end

class Test::Unit::TestCase
  def setup
    truncate! :person_ratings, :users, :movies, :actors
  end

  private

  def truncate!(*tables)
    [*tables].each do |t|
      ActiveRecord::Base.connection.execute("DELETE FROM #{t}")
    end
  end
end
