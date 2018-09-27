require 'lib/distance_calculator'
require 'lib/result_formatter'

require 'model/customer'
require 'model/error_report'
require 'model/location'
require 'model/result'


class App

  DUBLIN_OFFICE = Location.new(latitude: 53.339428, longitude: -6.257664)

  attr_accessor :options, :dublin_office_location, :result

  def initialize( args = {} )
    self.options = args[:options]
    self.dublin_office_location = args[:dublin_office_location] || DUBLIN_OFFICE
    self.result = Result.new
  end

  def run!
    # Read file one line at a time
    line_number = 0

    File.open(options[:filename], 'r').each_line do |line|
      # Parse + validate the JSON
      begin
        # increment first, as humans (and file viewers)
        # tend to count lines from 1 rather than 0
        line_number += 1
        process_line!(line)

      # if it failed, add it to the errors list
      rescue JSON::ParserError => e
        result.errors << ErrorReport.new(
          line_number: line_number,
          json: line.strip,
          exception: e
        )
      # ...any other exception (e.g. out of memory) we're just
      # going to let bubble out, as :
      # 1. we can't always know what the appropriate action would be, and
      # 2. there seems little point in swallowing, say, a file-not-found
      #    error, just to tell the user 'the file was not found' - they
      #    can get more information from the stack trace.
      #    (NOTE: this is just an assumption - that a cmd-line utility
      #     is more likely to be used by a tech-savvy user. This could
      #     of course be wrong, and for a real application, I'd want to
      #     know more about who would be using it and what for...)
      end
    end

    report_results
  end

  def report_results(stdout = STDOUT, stderr = STDERR)
    # Output results
    reporter = ResultFormatter.new(result: result)
    stdout.puts "Customers within 100km of the Dublin Office:"
    reporter.customers_to_invite(stdout)
    unless result.errors.empty?
      stdout.puts "\n"
      stderr.puts "Lines that couldn't be parsed:"
      reporter.errors(stderr)
    end
  end

  def process_line!(line)
    customer = Customer.from_json(line)

    # It is valid, so
    # work out the distance to the office
    distance = DistanceCalculator.km_between(
      DUBLIN_OFFICE,
      customer.location
    )

    # if it's less than 100km
    # add it to the invite list
    result.customers_to_invite << customer if distance <= 100.0
  end
end
