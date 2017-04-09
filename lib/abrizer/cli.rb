require 'thor'

if ENV['DEBUG_ABRIZER']
  require 'byebug'
end

module Abrizer
  class CLI < Thor

    # Adapted from http://stackoverflow.com/a/24829698/620065
    # Add a name for the option that allows for more variability
    class << self
      def add_shared_option(name, option_name, options = {})
        @shared_options = {} if @shared_options.nil?
        @shared_options[name] = [option_name, options]
      end

      def shared_options(*names)
        names.each do |name|
          opt =  @shared_options[name]
          raise "Tried to access shared option '#{option_name}' but it was not previously defined" if opt.nil?
          method_option *opt
        end
      end

      def input_banner
        'INPUT_FILEPATH'
      end

      def input_desc
        'Full or relative path to a mezzanine video file.'
      end
    end

    no_commands do
      def expand_path(path)
        File.expand_path path if path
      end
    end

    add_shared_option :input_required, :input, aliases: '-i', type: :string, required: true, banner: input_banner, desc: input_desc + ' Input file must be present.'
    add_shared_option :input_optional, :input, aliases: '-i', type: :string, required: false, banner: input_banner, desc: input_desc + ' May be used without an input file as long as preconditions are met.'
    add_shared_option :output, :output, aliases: '-o', type: :string, required: true, banner: 'OUTPUT_DIRECTORY', desc: 'Full or relative path to output directory for '
    add_shared_option :url, :url, aliases: '-u', type: :string, required: true, banner: 'BASE_URL', desc: 'Base URL to use in information files.'

    desc 'all', 'Run all processes including creating ABR streams, progressive download version, and images and video sprites. Optionally create a VP9 progressive download version.'
    shared_options :input_required, :output, :url
    method_option :vp9, type: :boolean, default: false
    def all
      filepath = expand_path options[:input]
      output_dir = expand_path options[:output]
      Abrizer::All.new(filepath, output_dir, options[:url], options[:vp9]).run
    end

    desc 'ffprobe', 'Save the output of ffprobe to a file as JSON'
    shared_options :input_required, :output
    def ffprobe
      filepath = expand_path options[:input]
      output_dir = expand_path options[:output]
      Abrizer::FfprobeFile.new(filepath, output_dir).run
    end

    desc 'adaptations', 'Output which adaptations will be created from input file to a JSON file and output to console'
    shared_options :input_optional, :output
    def adaptations
      input = expand_path options[:input]
      output = expand_path options[:output]
      adaptations = Abrizer::AdaptationsFile.new(input, output).adaptations
      puts adaptations
    end

    desc 'inform', 'Display raw ffprobe information about the video/audio file'
    shared_options :input_required
    def inform
      input = expand_path options[:input]
      informer = FfprobeInformer.new(filepath: input)
      puts informer.json_result
      puts informer
    end

    desc 'captions', 'Captions and subtitles files with the same basename as the video file and with a .vtt extension are copied over into the output directory'
    # TODO: Make input optional if packaging includes a VTT file already.
    shared_options :input_required, :output
    def captions
      filepath = expand_path options[:input]
      output_dir = expand_path options[:output]
      Abrizer::Captions.new(filepath, output_dir).copy
    end

    desc 'vp9', 'Create a single VP9 progressive download version from the original video.'
    shared_options :input_required, :output
    def vp9
      filepath = expand_path options[:input]
      output_dir = expand_path options[:output]
      Abrizer::ProgressiveVp9.new(filepath, output_dir).create
    end

    desc 'mp3', 'Create a progressive MP3 file from the audio of the original media'
    shared_options :input_required, :output
    def mp3
      filepath = expand_path options[:input]
      output_dir = expand_path options[:output]
      Abrizer::ProgressiveMp3.new(filepath, output_dir).create
    end

    desc 'sprites', 'Create image sprites and metadata WebVTT file'
    shared_options :input_required, :output
    def sprites
      filepath = expand_path options[:input]
      output_dir = expand_path options[:output]
      Abrizer::Sprites.new(filepath, output_dir).create
    end

    desc 'poster', 'Copy over a temporary poster image based on the sprite images'
    shared_options :output
    def poster
      output_dir = expand_path options[:output]
      Abrizer::TemporaryPoster.new(output_dir).copy
    end

    desc 'abr', 'From file create ABR streams, includes processing various fragmented MP4 adaptations for packaging first.'
    shared_options :input_required, :output
    def abr
      filepath = expand_path options[:input]
      output_dir = expand_path options[:output]
      Abrizer::Processor.process(filepath, output_dir)
      Abrizer::PackageDashBento.new(filepath, output_dir).package
      Abrizer::PackageHlsBento.new(filepath, output_dir).package
    end

    desc 'process', 'From mezzanine or preservation file create intermediary adaptations'
    shared_options :input_required, :output
    def process
      filepath = expand_path options[:input]
      output_dir = expand_path options[:output]
      Abrizer::Processor.process(filepath, output_dir)
    end

    desc 'mp4', 'Create a single progressive download version as an MP4 from the next to largest adaptation and audio. The adaptation and audio file must already exist.'
    shared_options :output
    def mp4
      output_dir = expand_path options[:output]
      Abrizer::ProgressiveMp4.new(output_dir).create
    end

    desc 'package <dash_or_hls>', "Package dash or hls from adaptations. Fragmented files, adaptions.json, and ffprobe.json must be present."
    shared_options :output
    def package(dash_or_hls)
      output_dir = expand_path options[:output]
      case dash_or_hls
      when "dash"
        Abrizer::PackageDashBento.new(output_dir).package
      when "hls"
        Abrizer::PackageHlsBento.new(output_dir).package
      when "all"
        Abrizer::PackageDashBento.new(output_dir).package
        Abrizer::PackageHlsBento.new(output_dir).package
      else
        puts "Not a valid packaging value. Try dash or hls."
      end
    end

    desc 'canvas', 'Creates a IIIF Canvas JSON-LD document as an API into the resources'
    shared_options :input_optional, :output, :url
    def canvas
      filepath = expand_path options[:input]
      output_directory = expand_path options[:output]
      Abrizer::Canvas.new(filepath, output_directory, options[:url]).create
    end

    desc 'data', 'Creates a JSON file with data about the video resources.'
    shared_options :input_optional, :output, :url
    def data
      filepath = expand_path options[:input]
      output_directory = expand_path options[:output]
      Abrizer::Data.new(filepath, output_directory, options[:url]).create
    end

    desc 'clean', 'Clean up intermediary files'
    shared_options :output
    def clean
      output_dir = expand_path options[:output]
      Abrizer::Cleaner.new(output_dir).clean
    end
  end
end
