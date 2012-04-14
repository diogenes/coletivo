require 'helper'
require 'models_helper'

class PersonTest < Test::Unit::TestCase
  def setup
    super
    @person = User.create(:name => 'Uber Geek')
  end

  should "be able to rate an object" do
    movie  = Movie.create(:name => 'Lovely Movie')
    @person.rate!(movie, 1)

    assert_equal 1, ratings_container.all.size
    assert_equal BigDecimal.new("1"), ratings_container.first.weight
  end

  should "be able to update a rating" do
    movie  = Movie.create(:name => 'Only Good Once Movie')

    @person.rate_or_update!(movie, 10)
    assert_equal BigDecimal.new("10"), ratings_container.first.weight

    @person.rate_or_update!(movie, 2)
    assert_equal BigDecimal.new("2"), ratings_container.first.weight

    assert_equal 1, ratings_container.all.size
  end
end
