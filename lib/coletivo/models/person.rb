module Coletivo
  module Models
    module Person
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # TODO: has_own_preferences doc.
        def has_own_preferences(options = {})
          self.send :include, InstanceMethods
        end
      end # ClassMethods

      module InstanceMethods
        def rate!(rateable, weight)
          Coletivo::Config.ratings_container.create!({
            :person => self,
            :rateable => rateable,
            :weight => weight
          })
        end

        def rate_or_update!(rateable, weight)
          r = Coletivo::Config.ratings_container.find_or_initialize_by_person_id_and_rateable_id_and_rateable_type(self.id, rateable.id, rateable.class)
          r.update_attributes! :person => self, :rateable => rateable, :weight => weight
        end
      end # InstanceMethods

    end # Person
  end # Models
end
