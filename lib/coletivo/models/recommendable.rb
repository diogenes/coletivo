module Coletivo
  module Models
    module Recommendable
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods
        def find_recommendations_for(model, options = {})
          sim_totals, weighted_means = {}, {}
          preferences = options[:preferences] ||=
            load_preferences_for_recommendation(model)

          preferences.each do |other, other_prefs|
            next if other == model

            sim = model.similarity_with(other, options)
            next if sim <= 0

            other_prefs.each do |item, weight|
              unless preferences[model.id].keys.include?(item)
                sim_totals[item] ||= 0
                weighted_means[item] ||= 0

                sim_totals[item] += sim
                weighted_means[item] += weight * sim
              end
            end
          end

          # DESC sort by weighted mean of ratings
          # e.g: [[5.35, "movie_2"], [2.0, "movie_4"]]
          top = weighted_means.collect { |i, mean| [mean/sim_totals[i], i] }\
            .sort { |t_one, t_other| t_other <=> t_one }

          ids = top.collect(&:last) # e.g: ['movie_2', 'movie_4']
          models = where(:id => ids)

          top.collect { |weight, item| models.detect {|m| m.id == item } }\
            .compact
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

        def load_preferences_for_recommendation(model)
          r = Coletivo::Config.ratings_container\
                .find_for_recommendation(model, self)

          map_ratings_to_preferences(r)
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
