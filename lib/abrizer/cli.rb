require 'thor'
module Abrizer
  class CLI < Thor

    desc 'abr FILE', 'From file create ABR streams'
    def abr(filename)
      Abrizer::Processor.process(filename)
      Abrizer::PackageDash.new(filename).package
      Abrizer::PackageHls.new(filename).package
    end

    desc 'process FILE', 'From mezzanine or preservation file create intermediary adaptations'
    def process(filename)
      Abrizer::Processor.process(filename)
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
        Abrizer::PackageDash.new(filename).package
      when "hls"
        Abrizer::PackageHls.new(filename).package
      when "all"
        Abrizer::PackageDash.new(filename).package
        Abrizer::PackageHls.new(filename).package
      else
        puts "Not a valid packaging value"
      end
    end

    desc 'clean <all_or_most> <filename>', 'Clean up intermediary files'
    def clean(all_or_most, filename)
      unless %w[ all most ].include? all_or_most
        puts "Not a valid cleaning mode!"
        exit
      end
      Abrizer::Cleaner.new(filename, all_or_most).clean
    end
  end
end
