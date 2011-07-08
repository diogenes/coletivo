module Coletivo
  module Models
    class PersonRating < ActiveRecord::Base
      belongs_to :person, :polymorphic => true
      belongs_to :rateable, :polymorphic => true

      validates :person, :rateable, :weight, :presence => true

      def self.find_for_recommendation(person, rateable_type)
        where(:rateable_type => rateable_type.to_s)
      end
    end
  end
end
