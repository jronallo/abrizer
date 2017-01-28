# Abrizer

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/abrizer`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'abrizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install abrizer

## Usage

Abrizer knows how to run various processes which can take a master or mezzanine video and create DASH and HLS streaming formats along with other derivatives like a fallback MP4 and . The gem is opinionated about what formats to create. The intention is to provide a relatively complete solution for delivering video.

Some steps must be run after others. Each has preconditions in order for subsequent steps to run and later cleaning steps will remove intermediate and log files. You can see the latest full set of processes Abrizer can run by looking in `lib/abrizer/cli.rb` for the `abr` method. The current order is:

- `process`: Process the adaptations that will be repackaged into ABR formats
- `package dash`: Package DASH (and HLS with fMP4) using output of `process`
- `package hls`: Package HLS (TS) using output of `process`
- `mp4`: Process a progressive download MP4 from original
- `vp9`: Process a progressive download WebM VP9 from original
- *Create video sprites and metadata WebVTT file (optionally retaining all the frame images for later picking a poster image)*
- `clean`: Clean out the intermediate and log files including MP4 files used for packaging but not required for delivery

Every command requires the path to the original video file and an output directory.

### Command Line

From the command line you can see help with: `abrizer`

To see help for a particular command run: `abrizer help abr`

If all you want to do is create the

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/abrizer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
