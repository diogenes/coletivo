module Coletivo
  module Models
    class PersonRating < ActiveRecord::Base
      belongs_to :person, :polymorphic => true
      belongs_to :rateable, :polymorphic => true

      validates :person, :rateable, :weight, :presence => true

      def self.find_for_recommendation(recommendable)
        find(:all)
      end
    end
  end
end
