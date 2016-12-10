require 'thor'
module Abrizer
  class CLI < Thor

    desc 'abr FILE', 'From file create ABR streams'
    def abr(filename)
      Abrizer::Processor.process(filename)
      Abrizer::PackageDashBento.new(filename).package
      Abrizer::PackageHlsBento.new(filename).package
      Abrizer::Static.new(filename).create
      Abrizer::Cleaner.new(filename).clean
    end

    desc 'process FILE', 'From mezzanine or preservation file create intermediary adaptations'
    def process(filename)
      Abrizer::Processor.process(filename)
    end

    desc 'static FILE', 'If intermediary adaptations are there create static transmuxed file'
    def static(filename)
      Abrizer::Static.new(filename).create
    end

    desc 'adaptations FILE', 'Display which adaptations will be created from input file'
    def adaptations(filename)
      adaptations = Abrizer::AdaptationFinder.new(filename).adaptations
      puts adaptations
    end

    desc 'inform FILE', 'Display information about the video/audio file'
    def inform(filename)
      informer = FfprobeInformer.new(filename)
      puts informer.json_result
      puts informer
    end

    desc 'package <dash_or_hls> <filename>', "Package dash or hls from adaptations"
    def package(dash_or_hls, filename)
      case dash_or_hls
      when "dash"
        Abrizer::PackageDashBento.new(filename).package
      when "hls"
        Abrizer::PackageHlsBento.new(filename).package
      when "all"
        Abrizer::PackageDashBento.new(filename).package
        Abrizer::PackageHlsBento.new(filename).package
      else
        puts "Not a valid packaging value"
      end
    end

    desc 'clean <filename>', 'Clean up intermediary files'
    def clean(filename)
      Abrizer::Cleaner.new(filename).clean
    end
  end
end
