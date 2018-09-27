
# invite_list

Parse the given customer list, and output any within 100km of the Dublin office,
sorted by ascending user_id.

Author:
  Al Davidson (apdavidson@gmail.com / https://github.com/aldavidson)

## Requirements:

- ruby 2.5.1
  (Developed on 2.5.1, in principle should be OK on any 2.x version,
  but this has not been tested)

- rubygems
  (should be installed as part of any Ruby version 1.9 or greater)

- bundler
(https://bundler.io/)

## To setup:
  (From the root directory of the repository)

  > bundle install

## Usage:

From the root directory of this repository, type:

```bash
./invite_list (options)
```

You can also run the ruby file manually if you want to:

```
bundle exec ruby invite_list.rb (options)
```

In either case, cmd-line options are:

- -h or --help
  (optional) Show help & usage info
- filename
  (optional) Filename to process.
  Defaults to sample_data/customers.txt
  which is the given sample from the brief

# Brief as given

## Customer Records

We have some customer records in a text file (customers.txt) -- one customer per line, JSON lines formatted. We want to invite any customer within 100km of our Dublin office for some food and drinks on us. Write a program that will read the full list of customers and output the names and user ids of matching customers (within 100km), sorted by User ID (ascending).

You can use the first formula from [this Wikipedia article](https://en.wikipedia.org/wiki/Great-circle_distance) to calculate distance. Don't forget, you'll need to convert degrees to radians.
The GPS coordinates for our Dublin office are 53.339428, -6.257664.
You can find the Customer list here.
We're looking for you to produce working code, with enough room to demonstrate how to structure components in a small program.



- Poor answers will be in the form of one big function. It’s impossible to test anything smaller than the entire operation of the program, including reading from the input file. Errors are caught and ignored.

- Good answers are well composed. Calculating distances and reading from a file are separate concerns. Classes or functions have clearly defined responsibilities. Test cases cover likely problems with input data.

- It’s an excellent answer if we've learned something from reading the code.



We recommend you use whatever language you feel strongest in. It doesn't have to be one we use!



⭑ Please submit code as if you intended to ship it to production. The details matter. Tests are expected, as is well written, simple idiomatic code.
