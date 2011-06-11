module Coletivo
  module Models
    class PersonRating < ActiveRecord::Base
      belongs_to :person, :polymorphic => true
      belongs_to :rateable, :polymorphic => true

      validates :person, :rateable, :weight, :presence => true
    end
  end
end
