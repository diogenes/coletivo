require 'helper'
require 'models_helper'

class PersonRatingTest < Test::Unit::TestCase
  def setup
    super
    @user = User.create(:name => 'A Good User')
    @movie = Movie.create(:name => 'The Tourist')
    @actress = Actor.create(:name => 'Angelina Jolie')
  end

  context '#find_for_recommendation' do
    should 'list only ratings of the type to recommend' do
      @user.rate!(@movie, 5.0)
      @user.rate!(@actress, 10.0) # :-)

      recommendations = Coletivo::Models::PersonRating.find_for_recommendation(@user, Movie)

      assert_equal 1, recommendations.size
    end
  end
end