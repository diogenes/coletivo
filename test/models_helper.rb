require 'coletivo'

class User < ActiveRecord::Base
  has_own_preferences
end

class Movie < ActiveRecord::Base
end

def ratings_container
  Coletivo::Config.ratings_container
end

