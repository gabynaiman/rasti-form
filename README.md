# Rasti::Form

[![Gem Version](https://badge.fury.io/rb/rasti-form.svg)](https://rubygems.org/gems/rasti-form)
[![CI](https://github.com/gabynaiman/rasti-form/actions/workflows/ci.yml/badge.svg)](https://github.com/gabynaiman/rasti-form/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/gabynaiman/rasti-form/badge.svg?branch=master)](https://coveralls.io/github/gabynaiman/rasti-form?branch=master)
[![Code Climate](https://codeclimate.com/github/gabynaiman/rasti-form.svg)](https://codeclimate.com/github/gabynaiman/rasti-form)

Forms validations

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rasti-form'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rasti-form

## Usage

### Form type coercion

```ruby
T = Rasti::Types

PointForm = Rasti::Form[x: T::Integer, y: T::Integer] # => PointForm[:x, :y]
form = PointForm.new x: '1', y: 2 # => #<PointForm[x: 1, y: 2]>
form.x # => 1
form.y # => 2
form.to_h # => {x: 1, y: 2}

PointForm.new x: true # => Validation errors:
                      #    - x: ["Invalid cast: true -> Rasti::Types::Integer"]
```

### Form validations

```ruby
class DateRangeForm < Rasti::Form
  TIME_FORMAT = '%d/%m/%Y'

  attribute :from, T::Time[TIME_FORMAT]
  attribute :to,   T::Time[TIME_FORMAT]

  private

  def validate
    if assert_present :from
      assert :from, from > Time.parse('2000-01-01'), 'From must be greater than 01/01/2000'
    end
    assert_present :to
    assert :from, from <= to, 'From must be less than To' if assigned?(:from) && assigned?(:to)
  end
end

DateRangeForm.new # => Validation errors:
                  #    - from: ["not present"]
                  #    - to: ["not present"]

DateRangeForm.new from: '15/07/1999', to: '08/10/2016' # => Validation errors: 
                                                       #    - from: ["From must be greater than 01/01/2000"]

DateRangeForm.new from: '20/10/2016', to: '08/10/2016' # => Validation errors: 
                                                       #    - from: ["From must be less than To"]

form = DateRangeForm.new from: '20/10/2016', to: '28/10/2016'
form.from # => 2016-10-20 00:00:00 -0300
form.to   # => 2016-10-28 00:00:00 -0300
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gabynaiman/rasti-form.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

