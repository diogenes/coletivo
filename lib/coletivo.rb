require 'rails'
require 'active_model'
require 'active_record'
require 'active_support'

module Coletivo
  module Models
    autoload :Recommendable, 'coletivo/models/recommendable'
    autoload :Person, 'coletivo/models/person'
    autoload :PersonRating, 'coletivo/models/person_rating'
  end

  module Similarity
    NO_SIMILARITY = -1.0..0.49
    SIMILAR = 0.5..0.99
    IDENTICAL = 1.0

    autoload :BaseStrategy, 'coletivo/similarity/base_strategy'
    autoload :EuclideanDistanceStrategy, 'coletivo/similarity/euclidean_distance_strategy'
    autoload :PearsonCorrelationStrategy, 'coletivo/similarity/pearson_correlation_strategy'
    autoload :Engine, 'coletivo/similarity/engine'
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
