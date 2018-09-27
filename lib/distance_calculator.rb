# see https://github.com/retoo/rvincenty for more info on rvincenty
require 'rvincenty'

class DistanceCalculator
  # accepts two Location objects, returns the distance between them in km
  # according to the Vincenty formula (most accurate at all distances,
  # according to the given Wikipedia article:
  # https://en.wikipedia.org/wiki/Great-circle_distance#Computational_formulas
  def self.km_between(location_1, location_2)
    # returns distance in metres - so divide by 1000 to get km
    RVincenty.distance(
      to_rvincenty_location(location_1),
      to_rvincenty_location(location_2)
    ) / 1000.00
  end

  private

  def self.to_rvincenty_location(location)
    [
      location.latitude.to_f,
      location.longitude.to_f
    ]
  end
end
