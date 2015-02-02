[![Build Status](https://travis-ci.org/ehlyzov/sreader.svg?branch=master)](https://travis-ci.org/ehlyzov/sreader)

# SReader

SReader provides DSL to generate ruby classes from data and describe transformation rule for each field. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sreader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sreader

## Usage

```ruby
include Sreader::DSL

Person = array do
  id :to_i  # :to_i will be converted to proc and applied for 'id'
  name
  bdate Date.method(:parse) # bdate will be converted to Date
  companies [ (array do # it is how to describe embedded structures
    id
	title
	position
  end) ]
  auth (dict do # auth is hash with following keys
    key
	secret
  end)
end

me = Person.new(["1", "Eugene", "1984-01-01", [["42", "Life LLC", "operator"]],
           { key: "KEY", secret: "SECRET"}])

p me.id                 # 1
p me.companies.first.id # "42"
p me.auth.key           # "KEY"
p Date === me.bdate     # true

```

See tests for more examples.

## Contributing

1. Fork it ( https://github.com/ehlyzov/sreader/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
