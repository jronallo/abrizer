require 'thor'
module Abrizer
  class CLI < Thor

    desc 'abr <filepath> <output_directory>', 'From file create ABR streams'
    def abr(filepath, output_dir=nil)
      Abrizer::Processor.process(filepath, output_dir)
      Abrizer::PackageDashBento.new(filepath).package
      Abrizer::PackageHlsBento.new(filepath).package
      Abrizer::Static.new(filepath).create
      Abrizer::Cleaner.new(filepath).clean
    end

    desc 'process <filepath> <output_directory>', 'From mezzanine or preservation file create intermediary adaptations'
    def process(filepath, output_dir=nil)
      Abrizer::Processor.process(filepath, output_dir)
    end

    desc 'static <filepath> <output_directory>', 'If intermediary adaptations are there create static transmuxed file'
    def static(filepath, output_dir=nil)
      Abrizer::Static.new(filepath).create
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

    desc 'clean <filepath> <output_directory>', 'Clean up intermediary files'
    def clean(filepath, output_dir=nil)
      Abrizer::Cleaner.new(filepath, output_dir).clean
    end
  end
end
