class Location
  attr_accessor :latitude, :longitude

  def initialize( params = {} )
    self.latitude = params[:latitude]
    self.longitude = params[:longitude]
  end
end
