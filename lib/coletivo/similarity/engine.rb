module Coletivo
  module Similarity
    class Engine
      def self.similarity_between(one, other, preferences, options = {})
        strategy = load_strategy options[:strategy]
        strategy.train_with(preferences)

        strategy.similarity_between(one, other)
      end

      protected

      def self.load_strategy(key)
        Coletivo::Similarity::EuclideanDistanceStrategy.new
      end
    end # Engine
  end # Similarity
end
