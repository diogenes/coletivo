module Coletivo
  module Models
    class PersonRating < ActiveRecord::Base
      belongs_to :person, :polymorphic => true
      belongs_to :rateable, :polymorphic => true

      validates :person, :rateable, :weight, :presence => true
      attr_accessible :person, :rateable, :weight

      def self.find_for_recommendation(person, rateable_type)
        where(:rateable_type => rateable_type.to_s)
      end

      def self.find_by_person(person)
        find_all_by_person(person).first
      end

      def self.find_all_by_person(person)
        where(:person_type => person.class.name, :person_id => person.id)
      end
    end
  end
end
