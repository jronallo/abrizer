require 'thor'
module Abrizer
  class CLI < Thor

    desc 'all <filepath> <output_directory>', 'Runn all processes including creating ABR streams, progressive download versions, and images and video sprites'
    def all(filepath, output_dir=nil)
      filepath = File.expand_path filepath
      output_dir = File.expand_path output_dir
      Abrizer::All.new(filepath, output_dir).run
    end

    desc 'abr <filepath> <output_directory>', 'From file create ABR streams, includes processing MP4 adaptations for packaging'
    def abr(filepath, output_dir=nil)
      filepath = File.expand_path filepath
      output_dir = File.expand_path output_dir
      Abrizer::Processor.process(filepath, output_dir)
      Abrizer::PackageDashBento.new(filepath, output_dir).package
      Abrizer::PackageHlsBento.new(filepath, output_dir).package
    end

    desc 'process <filepath> <output_directory>', 'From mezzanine or preservation file create intermediary adaptations'
    def process(filepath, output_dir=nil)
      filepath = File.expand_path filepath
      output_dir = File.expand_path output_dir
      Abrizer::Processor.process(filepath, output_dir)
    end

    desc 'mp4 <filepath> <output_directory>', 'Create a single progressive download version as an MP4 from the next to largest adaptation and audio. The adaptation and audio file must already exist.'
    def mp4(filepath, output_dir=nil)
      filepath = File.expand_path filepath
      output_dir = File.expand_path output_dir
      Abrizer::ProgressiveMp4.new(filepath, output_dir).create
    end

    desc 'vp9 <filepath> <output_directory>', 'Create a single VP9 progressive download version from the original video.'
    def vp9(filepath, output_dir=nil)
      filepath = File.expand_path filepath
      output_dir = File.expand_path output_dir
      Abrizer::ProgressiveVp9.new(filepath, output_dir).create
    end

    desc 'adaptations <filepath>', 'Display which adaptations will be created from input file'
    def adaptations(filepath)
      adaptations = Abrizer::AdaptationFinder.new(filepath).adaptations
      puts adaptations
    end

    desc 'inform <filepath>', 'Display information about the video/audio file'
    def inform(filepath)
      informer = FfprobeInformer.new(filepath)
      puts informer.json_result
      puts informer
    end

    desc 'package <dash_or_hls> <filepath> <output_directory>', "Package dash or hls from adaptations"
    def package(dash_or_hls, filepath, output_dir=nil)
      filepath = File.expand_path filepath
      output_dir = File.expand_path output_dir
      case dash_or_hls
      when "dash"
        Abrizer::PackageDashBento.new(filepath, output_dir).package
      when "hls"
        Abrizer::PackageHlsBento.new(filepath, output_dir).package
      when "all"
        Abrizer::PackageDashBento.new(filepath, output_dir).package
        Abrizer::PackageHlsBento.new(filepath, output_dir).package
      else
        puts "Not a valid packaging value. Try dash or hls."
      end
    end

    desc 'sprites <filepath> <output_directory>', 'Create image sprites and metadata WebVTT file'
    def sprites(filepath, output_dir=nil)
      filepath = File.expand_path filepath
      output_dir = File.expand_path output_dir
      Abrizer::Sprites.new(filepath, output_dir).create
    end

    desc 'captions <filepath> <output_directory>', 'Captions and subtitles files with the same basename as the video file and with a .vtt extension are copied over into the output directory'
    def captions(filepath, output_dir=nil)
      filepath = File.expand_path filepath
      output_dir = File.expand_path output_dir
      Abrizer::Captions.new(filepath, output_dir).copy
    end

    desc 'clean <filepath> <output_directory>', 'Clean up intermediary files'
    def clean(filepath, output_dir=nil)
      Abrizer::Cleaner.new(filepath, output_dir).clean
    end
  end
end
