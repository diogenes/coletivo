require 'helper'

class ColetivoTest < Test::Unit::TestCase
  should "be able to change the ratings container class" do
    config = Coletivo::Config.dup
    config.ratings_container = Object

    assert_equal Object, config.ratings_container
    config.ratings_container = Coletivo::Models::PersonRating
  end
end
