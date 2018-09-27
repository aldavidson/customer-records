#!/usr/bin/ruby

require_relative './app_setup'

require 'byebug'
require 'json'

require 'app'

def usage
<<-END
invite_list
-----------

Parse the given customer list, and output any within 100km of the Dublin office,
sorted by ascending user_id.

Author:
  Al Davidson (apdavidson@gmail.com / https://github.com/aldavidson)

Requirements:

- ruby 2.5.1
  (Developed on 2.5.1, in principle should be OK on any 2.x version,
  but this has not been tested)

- rubygems
  (should be installed as part of any Ruby version 1.9 or greater)

- bundler
(https://bundler.io/)

To setup:
  (From the root directory of the repository)

  > bundle install

Usage:

  From the root directory of this repository, type:

  > ./invite_list (options)

  You can also run the ruby file manually if you want to:

  > bundle exec ruby invite_list.rb (options)

  In either case, cmd-line options are:

  -h or --help    -   (optional) Show this message
  filename        -   (optional) Filename to process.
                      Defaults to sample_data/customers.txt
                      which is the given sample from the brief

END
end

options = {}
# default file is the given sample
options[:filename] = File.join(File.dirname(__FILE__), 'sample_data', 'customers.txt')

# handle any given cmd-line option
unless Array(ARGV).empty?
  if ['-h', '--help'].include?(ARGV[0])
    puts usage
    exit
  else
    options[:filename] = ARGV[0]
  end
end
# run the app
App.new(options: options).run!
