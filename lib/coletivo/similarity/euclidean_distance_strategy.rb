module Coletivo
  module Similarity
    class EuclideanDistanceStrategy < BaseStrategy
      def similarity_between(one, other)
        shared = shared_items_between(one, other)

        return 0 if shared.empty?

        sum_of_squares = shared.inject(0.0) { |sum, item|
          sum + (preferences[one][item] - preferences[other][item]) ** 2
        }

        1 / (1 + sum_of_squares)
      end
    end
  end
end # Similarity

