# GemDependenciesVisualizer

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/gem_dependencies_visualizer`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gem_dependencies_visualizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gem_dependencies_visualizer

## Usage

To produce a graph of your gem dependencies, pass the content of a Gemfile.lock as is as an input to the visualizer. You can (optionaly) pass a graph name you might want to give to the .png file to be produced. 

To use it just run the following in your code:

```ruby
GemDependenciesVisualizer.produce_gems_graph(gemfile_lock_string, graph_name)
```

For example by using the produced Gemfile.lock in this gem, we can get the following:

![Sample produced graph](https://raw.githubusercontent.com/arcanoid/gem_dependencies_visualizer/master/sample_images/graph_sample.png)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arcanoid/gem_dependencies_visualizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

