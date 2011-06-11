module Coletivo
  module Similarity
    class PearsonCorrelationStrategy < BaseStrategy
      def similarity_between(one, other)
        shared      = shared_items_between(one, other)
        prefs_one   = preferences[one]
        prefs_other = preferences[other]

        return 0 if shared.empty?

        sum_prefs_one = sum_prefs_other = sum_squares_one = \
          sum_squares_other = p_sum = 0.0

        shared.each { |item|
          sum_prefs_one     += prefs_one[item]
          sum_prefs_other   += prefs_other[item]
          sum_squares_one   += prefs_one[item] ** 2
          sum_squares_other += prefs_other[item] ** 2
          p_sum             += prefs_one[item] * prefs_other[item]
        }

        total_shared = shared.size

        numerator = p_sum - (sum_prefs_one * sum_prefs_other / total_shared)

        den_one = sum_squares_one - (sum_prefs_one ** 2) / total_shared
        den_other = sum_squares_other - (sum_prefs_other ** 2) / total_shared

        denominator = Math.sqrt(den_one * den_other)

        denominator == 0 ? 0 : numerator / denominator
      end
    end
  end
end
