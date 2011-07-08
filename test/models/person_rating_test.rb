require 'helper'
require 'models_helper'

class PersonRatingTest < Test::Unit::TestCase
  subject { Coletivo::Models::PersonRating.new }

  should validate_presence_of(:person)
  should validate_presence_of(:rateable)
  should validate_presence_of(:weight)

  context "#find_for_recommendation" do
    subject { Coletivo::Models::PersonRating }

    should "list only ratings of the type to recommend" do
      user = User.create(:name => 'A Good User')
      movie = Movie.create(:name => 'The Tourist')
      actress = Actor.create(:name => 'Angelina Jolie')

      user.rate!(movie, 5.0)
      user.rate!(actress, 10.0) # :-)

      recommendations = subject.find_for_recommendation(user, Movie)

      assert_equal 1, recommendations.size
    end
  end
end
