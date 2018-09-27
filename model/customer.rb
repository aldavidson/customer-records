require 'json'
require 'byebug'
require 'lib/hash_symbolizer'

require 'model/location'

class Customer
  attr_accessor :user_id, :name, :location

  def initialize(params = {})
    self.user_id = params[:user_id]
    self.name = params[:name]
    self.location = params[:location] || parse_given_coordinates(params)
  end

  def parse_given_coordinates(params = {})
    if params[:longitude] && params[:latitude]
      Location.new(
        latitude: params[:latitude],
        longitude: params[:longitude]
      )
    end
  end

  def self.from_json( string )
    parsed_json = JSON.parse(string)
    new( HashSymbolizer.symbolize(parsed_json) )
  end
end
