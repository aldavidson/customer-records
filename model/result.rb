class Result
  attr_accessor :customers_to_invite, :errors

  def initialize( args = {} )
    self.customers_to_invite = args[:customers_to_invite] || []
    self.errors = args[:errors] || []
  end

  def sorted_customers
    self.customers_to_invite.sort_by(&:user_id)
  end
end
