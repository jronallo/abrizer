module Abrizer
  class Cleaner

    include FilepathHelpers

    def initialize(filename)
      @filename = filename
      @adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
    end

    def clean
      delete_adaptations(@adaptations)
      clean_audio_file
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

  end
end
