module Abrizer
  class ProgressiveMp4

    include FilepathHelpers

    def initialize(filename, output_dir=nil)
      @filename = filename
      @output_directory = output_dir
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

    def input_video_filepath
      @adaptation.filepath_fragmented(@filename, output_directory)
    end

    def ffmpeg_cmd
      "ffmpeg -y -i #{input_video_filepath} -i #{audio_filepath_fragmented} -c:v copy -c:a copy #{static_filepath}"
    end

    def static_filepath
      File.join output_directory, "progressive.mp4"
    end

  end
end
