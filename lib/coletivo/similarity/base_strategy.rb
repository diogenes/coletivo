module Coletivo
  module Similarity
    class BaseStrategy
      attr_accessor :preferences

      def similarity_between(one, other)
        raise "The #similarity_between was not implemented in #{self.class}"
      end

      def train_with(people_preferences)
        @preferences = people_preferences
      end

      protected

      def shared_items_between(one, other)
        return [] unless preferences[one] && preferences[other]

        preferences[one].keys.select { |item|
          preferences[other].keys.include? item
        }
      end
    end
  end # Similarity
end # Coletivo
