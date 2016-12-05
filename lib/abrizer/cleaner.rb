module Abrizer
  class Cleaner

    include FilepathHelpers

    def initialize(filename, mode)
      @filename = filename
      @mode = mode
      @adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
    end

    def clean
      clean_all_video_adaptations if all?
      clean_most_video_adaptations if most?
      clean_audio_file
    end

    def clean_all_video_adaptations
      delete_adaptations(@adaptations)
    end

    def clean_most_video_adaptations
      sorted = @adaptations.sort_by do |adaptation|
        adaptation.width
      end
      sorted.delete_at -2
      delete_adaptations(sorted)
    end

    def delete_adaptations(adapts)
      adapts.map do |adaptation|
        filepath = adaptation.filepath(@filename)
        FileUtils.rm filepath if File.exist? filepath
      end
    end

    def clean_audio_file
      FileUtils.rm audio_filepath if File.exist? audio_filepath
    end

    def all?
      @mode == 'all'
    end

    def most?
      @mode == 'most'
    end

  end
end
