require 'helper'
require 'models_helper'

class RecommendableTest < Test::Unit::TestCase
  def setup
    super

    @person1 = User.create(:name => 'Person 1')
    @person2 = User.create(:name => 'Person 2')
  end

  [:euclidean, :pearson].each do |strategy|
    context "using #{strategy.to_s.upcase}" do
      should "matches perfect similarity when preferences are identical" do
        m1 = Movie.create(:name => 'Movie 1')
        m2 = Movie.create(:name => 'Movie 2')

        p = {
          @person1.id => {m1.id => 2.5, m2.id => 1.0},
          @person2.id => {m1.id => 2.5, m2.id => 1.0}
        }

        sim = similarity_between(@person1, @person2, p, strategy)

        assert_equal Coletivo::Similarity::IDENTICAL, sim
      end

      should "matches no similarity when preferences are very different" do
        m1 = Movie.create(:name => 'Movie 1')
        m2 = Movie.create(:name => 'Movie 2')

        p = {
          @person1.id => {m1.id => 1.0, m2.id => 10.0},
          @person2.id => {m1.id => 10.0, m2.id => 1.0}
        }

        sim = similarity_between(@person1, @person2, p, strategy)

        assert Coletivo::Similarity::NO_SIMILARITY.include?(sim)
      end

      should "matches similarity when preferences are similar" do
        m1 = Movie.create(:name => 'Movie 1')
        m2 = Movie.create(:name => 'Movie 2')

        p = {
          @person1.id => {m1.id => 3.0, m2.id => 5.0},
          @person2.id => {m1.id => 4.0, m2.id => 5.0}
        }

        sim = similarity_between(@person1, @person2, p, strategy)

        assert Coletivo::Similarity::SIMILAR.include?(sim) ||
               Coletivo::Similarity::IDENTICAL == sim
      end

      should "recommend items for a person - sorted by better ratings" do
        person3 = User.create(:name => 'Person 3')

        m1 = Movie.create(:name => 'Movie 1')
        m2 = Movie.create(:name => 'Movie 2')
        m3 = Movie.create(:name => 'Movie 3')
        m4 = Movie.create(:name => 'Movie 4')

        p = {
          @person1.id => {m1.id => 2.0, m3.id => 1.0},
          @person2.id => {m1.id => 1.5, m2.id => 4.7, m3.id => 1.5, m4.id => 2.5},
          person3.id => {m1.id => 2.5, m2.id => 6.0, m3.id => 0.5, m4.id => 1.5}
        }

        recommendations = Movie.find_recommendations_for(@person1,
          :preferences => p, :strategy => strategy)

        assert recommendations.index(m2) < recommendations.index(m4)
      end

      should "be able to recommend a limited number of items" do
        person3 = User.create(:name => 'Person 3')

        m1 = Movie.create(:name => 'Movie 1')
        m2 = Movie.create(:name => 'Movie 2')
        m3 = Movie.create(:name => 'Movie 3')
        m4 = Movie.create(:name => 'Movie 4')

        p = {
          @person1.id => {m1.id => 2.0, m3.id => 1.0},
          @person2.id => {m1.id => 1.5, m2.id => 4.7, m3.id => 1.5, m4.id => 2.5},
          person3.id => {m1.id => 2.5, m2.id => 6.0, m3.id => 0.5, m4.id => 1.5}
        }

        assert_equal 1, Movie.find_recommendations_for(@person1,
          :preferences => p, :strategy => strategy, :limit => 1).size
      end

      should "report true when a person has rated an item" do
        person3 = User.create(:name => 'Person 3')

        m1 = Movie.create(:name => 'Movie 1')

        person3.rate! m1, -1
        m1.reload

        assert_equal true, m1.has_been_rated_by?(person3)
      end

      should "report false when a person has not rated an item" do
        person3 = User.create(:name => 'Person 3')

        m1 = Movie.create(:name => 'Movie 1')
        m1.reload

        assert_equal false, m1.has_been_rated_by?(person3)
      end

      should "report true what a person has rated an item with" do
        person3 = User.create(:name => 'Person 3')

        m1 = Movie.create(:name => 'Movie 1')

        person3.rate! m1, -1
        m1.reload

        assert_equal -1, m1.rating_of(person3)
      end
    end
  end

  def similarity_between(one, other, preferences, strategy)
    one.similarity_with(other.id, :preferences => preferences,
      :strategy => strategy)
  end
end
