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

          ratings_params = ActionController::Parameters.new(:rating => {
                                                                :person_type => self.class.name,
                                                                :person_id => self.id,
                                                                :rateable_type => rateable.class.name,
                                                                :rateable_id => rateable.id,
                                                                :weight => weight
                                                            })
          ratings_params = ratings_params.require(:rating).permit(:weight, :person_type, :person_id, :rateable_type, :rateable_id)

          Coletivo::Config.ratings_container.create!(ratings_params)
        end
      end # InstanceMethods

    end # Person
  end # Models
end
