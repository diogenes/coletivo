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
  end
end
