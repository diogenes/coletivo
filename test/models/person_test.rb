require 'helper'
require 'models_helper'

class PersonTest < Test::Unit::TestCase
  def setup
    super
    @person = User.create(:name => 'Uber Geek')
    @movie  = Movie.create(:name => 'Lovely Movie')
  end

  should "be able to rate an object" do

    @person.rate!(@movie, 1)

    assert_equal 1, ratings_container.all.size
  end
end
