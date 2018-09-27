# Formats the customers & invalid lines for output
# I decided to keep these within one class, rather than as methods on the
# model objects, because:
# 1. it's one concern (formatting for output)
# 2. I like to keep models thin, and free of presentation code
# 3. I like to keep the .to_s methods on models working as expected
#   (i.e. an inspection of the model's attributes)
# There's always exceptions to the above rules, of course, they're more
# like rules-of-thumb. I think they hold in this case, but quite happy to
# be persuaded otherwise.
class ResultFormatter
  attr_accessor :result

  def initialize( args = {} )
    self.result = args[:result]
  end

  def customers_to_invite(out = STDOUT)
    result.sorted_customers.each do |customer|
      out << formatted_customer(customer) + "\n"
    end
  end

  def errors(out = STDERR)
    result.errors.each do |error|
      out << formatted_error(error) + "\n"
    end
  end

  private

  def formatted_customer(customer)
    [customer.user_id, customer.name].join(', ')
  end


  def formatted_error(error)
    "line #{error.line_number}: #{error.exception.message} (json: \"#{error.json}\")"
  end
end
