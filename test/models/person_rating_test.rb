require 'helper'
require 'models_helper'

class PersonRatingTest < Test::Unit::TestCase
  subject { Coletivo::Models::PersonRating.new }

  should validate_presence_of(:person)
  should validate_presence_of(:rateable)
  should validate_presence_of(:weight)
end
