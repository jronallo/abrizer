# Abrizer

Abrizer takes a source video and creates various derivatives for delivery including adaptive bitrate formats like DASH and HLS. An opinionated work in progress.

## Requirements

See `ansible/development-playbook.yml` for specifics on all requirements.

- ffmpeg with x264 and libvpx
- bento4
- Imagemagick (convert and montage) for sprites

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'abrizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install abrizer

See [Vagrant](#vagrant) below for one way to install dependencies and run the scripts.

## Usage

Abrizer knows how to run various processes which can take a master or mezzanine video and create DASH and HLS streaming formats along with other derivatives like a fallback MP4 and WebM. The gem is opinionated about what formats to create and what settings to use. The intention is to provide a relatively complete but simple solution for delivering video over HTTP.

Some steps must be run after others as they have preconditions in order for subsequent steps to run. Later cleaning steps will remove intermediate and log files. You can see the latest full set of processes Abrizer can run by looking in `lib/abrizer/cli.rb` for the `abr` method. The current order is:

- `process`: Process the adaptations that will be repackaged into ABR formats
- `package dash`: Package DASH (and HLS with fMP4) using output of `process`
- `package hls`: Package HLS (TS) using output of `process`
- `mp4`: Process a progressive download MP4 from original
- `vp9`: Process a progressive download WebM VP9 from original
- `sprites`: Create video sprites and metadata WebVTT file retaining all the images in order for a human to later pick a poster image
- `poster`: Copies over a temporary poster image from the output of the sprites
- `clean`: Clean out the intermediate and log files including MP4 files used for packaging but not required for delivery

All of the above commands require the path to the original video file and an output directory.

### Command Line

From the command line you can see help with: `abrizer`

To see help for a particular command run: `abrizer help abr`

You can run all steps with:
`abrizer all /path/to/video.mp4 /path/to/output_directory http://localhost:8088/v`

Or just create various adaptations needed for repackaging to DASH and HLS:
`abrizer process /path/to/video.mp4 /path/to/output_directory`

Then once `process` is run it is possible to do packaging to adaptive bitrate formats like DASH:

`abrizer package dash /path/to/video.mp4 /path/to/output_directory`

The output for DASH will go in the `fmp4` directory as the fragmented MP4 can be used for both DASH (stream.mpd) and the latest HLS on iOS 10+ (master.m3u8).

HLS with MPEG-2 TS files can also be created after `process` is run with the output in the `hls` directory:

`abrizer package hls /path/to/video.mp4 /path/to/output_directory`

### Using as a Library

If you simply want to run all the steps, you can use the `Abrizer::All` class like so:

```ruby
video_path = "/path/to/video.mp4"
output_directory = "/path/to/output_directory"
Abrizer::All.new(video_path, output_directory).run
```

Take a look at `lib/abrizer/all.rb` for how to use the various classes provided. You can also see more examples in `lib/abrizer/cli.rb`. All classes expect to be passed the fully expanded path.

### Canvas

Experimental support is provided for creating a IIIF Canvas. Note that this work is done in advance of a draft standard for including video in a IIIF manifest. It can be created after other steps with `abrizer help canvas` for more information.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Vagrant

The easiest way to do development on Abrizer or even try out the scripts is to use a Vagrant machine. If you have Vagrant and Virtualbox installed just run `vagrant up` and all dependencies will be installed.

This includes a web server that can be used for local testing of streams and videos. After `vagrant up` visit http://localhost:8088/v/ to see the contents of the project's `tmp` directory. Within the virtual machine (`vagrant ssh`) you can process a test video with:

```shell
cd /vagrant
bundle exec exe/abrizer all test/videos/FullHDCinemaCountdown720p-8sec.mp4 tmp/countdown http://localhost:8088/v
```

Now visit http://localhost:8088/v/countdown/ to see the files that were created. You can then test any of the videos or streams.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jronallo/abrizer.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
