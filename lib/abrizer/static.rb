module Abrizer
  class Static

    include FilepathHelpers

    def initialize(filename)
      @filename = filename
      find_adaptation
    end

    def create
      `#{ffmpeg_cmd}`
    end

    def find_adaptation
      adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
      sorted = adaptations.sort_by do |adaptation|
       adaptation.width
      end
      @adaptation = sorted[-2]
    end

    def ffmpeg_cmd
      "ffmpeg -y -i #{@adaptation.filepath(@filename)} -i #{audio_filepath} -c:v copy -c:a copy #{static_filepath}"
    end

    def static_filepath
      File.join output_directory, "#{basename}.mp4"
    end

  end
end
