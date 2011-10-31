module Coletivo
  module Models
    module Recommendable
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods
        def find_recommendations_for(person, options = {})
          preferences = options[:preferences] ||=
            load_preferences_for_recommendation(person)
          top = predict_highest_ratings(person, preferences, options)
          ids = top.collect(&:last)

          where(:id => ids).limit(options[:limit]).all
        end

        def map_ratings_to_preferences(ratings)
          #TODO: (???) Item based mapping.
          key, subkey = :person_id, :rateable_id
          preferences = {}

          ratings.each do |rating|
            p = preferences[rating.send(key)] ||= {}
            p[rating.send(subkey)] = rating.weight
          end

          preferences
        end

        def load_preferences_for_recommendation(person)
          r = Coletivo::Config.ratings_container\
                .find_for_recommendation(person, self)

          map_ratings_to_preferences(r)
        end

        private

        def predict_highest_ratings(person, people_preferences, options)
          data = {}
          people_preferences.each do |other, other_prefs|
            next if other == person

            sim = person.similarity_with(other, options)
            next if sim <= 0

            other_prefs.each do |item, weight|
              unless people_preferences[person.id].keys.include?(item)
                data[item] ||= {:total_similarity => 0.0, :weighted_mean => 0.0}
                data[item][:total_similarity] += sim
                data[item][:weighted_mean] += weight * sim
              end
            end
          end

          # e.g: [[5.35, "movie_2"], [2.0, "movie_4"]]
          guessed_rating_and_id = Proc.new do |item, item_data|
            [item_data[:weighted_mean] / item_data[:total_similarity], item]
          end

          # DESC sorting by weighted mean of ratings
          data.collect(&guessed_rating_and_id).sort_by(&:first).reverse
        end
      end

      module InstanceMethods
        def similarity_with(other_id, options = {})
          p = options[:preferences] ||
            self.class.load_preferences_for_recommendation(self)

          Coletivo::Similarity::Engine\
            .similarity_between(self.id, other_id, p, options)
        end
      end
    end # Recommendable
  end # Models
end
