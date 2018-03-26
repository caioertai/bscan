# Deals with Similarity Ratings
class SimilarityService
  attr_reader :obj1, :obj2, :includes, :rating

  def initialize(obj1, obj2, weights = {})
    @lev_weight = weights[:lev_weight] || 2
    @pair_weight = weights[:pair_weight] || 1
    @obj1 = obj1
    @obj2 = obj2
    @obj1_name = obj1.is_a?(String) ? obj1 : obj1.name.downcase
    @obj2_name = obj2.is_a?(String) ? obj2 : obj2.name.downcase
    lev_rating
    pair_rating
    rate.round
  end

  def lev_rating
    @lev_rating = @obj1_name.levenshtein_similar(@obj2_name) * 100
  end

  def pair_rating
    @pair_rating = @obj1_name.pair_distance_similar(@obj2_name) * 100
  end

  def inclusion?
    @obj1_name.include?(@obj2_name) || @obj2_name.include?(@obj1_name)
  end

  def rate
    weighted_average = ((@lev_rating * @lev_weight + @pair_rating * @pair_weight) / (@lev_weight + @pair_weight))
    @rating = inclusion? ? weighted_average + ((100 - weighted_average) / 2) : weighted_average
  end
end
