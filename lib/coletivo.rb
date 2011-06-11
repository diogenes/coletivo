require 'rails'
require 'active_model'
require 'active_record'
require 'active_support'

module Coletivo
  module Models
    autoload :Person, 'coletivo/models/person'
    autoload :PersonRating, 'coletivo/models/person_rating'
  end

  module Config
    mattr_accessor :ratings_container

    # Defaults
    self.ratings_container = Coletivo::Models::PersonRating
  end

  if defined?(Rails)
    require 'coletivo/rails/engine'
    require 'coletivo/rails/active_record'
  end
end
