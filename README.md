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

## Versioning

API may change in breaking ways in minor versions until version 1.0.0 when breaking changes will update the major version number.

## Usage

Abrizer knows how to run various processes which can take a master or mezzanine video and create various access derivative formats including DASH and HLS streaming formats as well as fallback MP4 and WebM (VP9). The gem is opinionated about what formats to create and what settings to use. The intention is to provide a relatively complete but simple solution for delivering video over HTTP for HTML5 video.

Some steps must be run after others as they have preconditions in order for subsequent steps to run. You can see the latest full set of processes Abrizer can run by looking in `lib/abrizer/all.rb`. The initial commands before `process` need to run with the mezzanine file as input. The current order is:

- `ffprobe`: Saves the output of ffprobe to `ffprobe.json`. This way the mezzanine file does not have to be present for some later steps.
- `adaptations`: Saves the precomputed adaptations that will be created in later processes to `adaptations.json`.
- `captions`: Copies over captions.
- `vp9`: Process a progressive download WebM VP9 from original. This takes a long time.
- `mp3`: Create a progressive download MP3 audio file.
- `sprites`: Create video thumbnail sprites and metadata WebVTT file retaining all the images in order for a human to later pick a poster image.
  - `poster`: Copies over a temporary poster image from the output of the `sprites` command.
- `process`: Process the adaptations that will be repackaged into ABR formats. Beyond this point the remaining processes can be run without the mezzanine file present.
  - `mp4`: Process a progressive download MP4 from next to highest quality adaptation.
  - `package dash`: Package DASH (and HLS with fMP4) using output of `process`.
  - `package hls`: Package HLS (TS) using output of `process`.
- `canvas`: Non-standard IIIF canvas.
- `waveform`: Create audio waveform data.
- `data`: Create the data.json file.
- `clean`: Clean out the intermediate and log files including MP4 files used for packaging but not required for delivery.

### Media Sharing

The `canvas` and `data` create files that aid in sharing media. They create `canvas.json` and `data.json` files respectively. You must know the base URL that will be used to serve up the media files. The `canvas.json` is experimental support for the developing [IIIF A/V technical specification](http://iiif.io/community/groups/av/) for canvases. Note that this work is done in advance of a draft standard for including video in a IIIF manifest. The `data.json` file is a simplified version of the information about the available media.

In order to get information about the files being shared these steps either need the presence of the original video file or the presence of the `ffprobe.json` and `adaptations.json` files. In addition these information files are only useful if some media has already been processed. In other words these processes can be run without the presence of the mezzanine file if some preconditions are already met.

### Command Line

From the command line you can see help with: `abrizer`

To see help for a particular command run: `abrizer help all`

You can run all steps with:
`abrizer all -i /path/to/video.mp4 -o /path/to/output_directory -u http://localhost:8088/v/output_directory`

Or just create various adaptations needed for repackaging to DASH and HLS:
`abrizer process -i /path/to/video.mp4 -o /path/to/output_directory`

Then once `process` is run it is possible to do packaging to adaptive bitrate formats like DASH:

`abrizer package dash -o /path/to/output_directory`

The output for DASH will go in the `fmp4` directory as the fragmented MP4 can be used for both DASH (stream.mpd) and the latest HLS on iOS 10+ (master.m3u8).

HLS with MPEG-2 TS files can also be created after `process` is run with the output in the `hls` directory:

`abrizer package hls -o /path/to/output_directory`

### Using as a Library

If you simply want to run all the steps, you can use the `Abrizer::All` class like so:

```ruby
video_path = "/path/to/video.mp4"
output_directory = "/path/to/output_directory"
base_url = "http://localhost:8088/v/output_directory"
Abrizer::All.new(video_path, output_directory, base_url).run
```

Take a look at `lib/abrizer/all.rb` for how to use the various classes provided. You can also see more examples in `lib/abrizer/cli.rb`. All classes expect to be passed the fully expanded path.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests (when there are tests!). You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Vagrant

The easiest way to do development on Abrizer or even try out the scripts is to use a Vagrant machine. If you have Vagrant and Virtualbox installed just run `vagrant up` and all dependencies will be installed.

This includes a web server that can be used for local testing of streams and videos. After `vagrant up` visit http://localhost:8088/v/ to see the contents of the project's `tmp` directory. Within the virtual machine (`vagrant ssh`) you can process a test video with:

```shell
cd /vagrant
bundle exec exe/abrizer all \
-i test/videos/FullHDCinemaCountdown720p-8sec.mp4 \
-o tmp/countdown -u http://localhost:8088/v/countdown
```

Now visit http://localhost:8088/v/countdown/ to see the files that were created. You can then test any of the videos or streams.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jronallo/abrizer.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
