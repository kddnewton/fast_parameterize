# `String#parameterize` Ruby Extension

[![Build Status](https://github.com/kddnewton/fast_parameterize/workflows/Main/badge.svg)](https://github.com/kddnewton/fast_parameterize/actions)
[![Gem Version](https://img.shields.io/gem/v/fast_parameterize.svg)](https://rubygems.org/gems/fast_parameterize)

`fast_parameterize` is a C extension that provides a fast implementation of [ActiveSupport's `String#parameterize` method](http://api.rubyonrails.org/classes/String.html#method-i-parameterize).

## Is it fast?

At last check, these were the benchmarks (obtained by running `bin/bench` with ActiveSupport 6.1.3):

```
Warming up --------------------------------------
       ActiveSupport     8.000  i/100ms
    FastParameterize   131.000  i/100ms
Calculating -------------------------------------
       ActiveSupport     82.566  (± 2.4%) i/s -    416.000  in   5.042230s
    FastParameterize      1.308k (± 3.4%) i/s -      6.550k in   5.014582s

Comparison:
    FastParameterize:     1308.0 i/s
       ActiveSupport:       82.6 i/s - 15.84x  (± 0.00) slower
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fast_parameterize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fast_parameterize

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddnewton/fast_parameterize.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
