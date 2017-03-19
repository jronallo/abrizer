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
      "ffmpeg -y -i #{input_video_filepath} -i #{audio_filepath_fragmented} -c:v copy -c:a copy #{mp4_filepath} -movflags faststart"
      # Previously used command:
      # "ffmpeg -y -i #{@filename} -profile:v high -pix_fmt yuv420p -movflags faststart -b:v #{@adaptation.bitrate}k #{mp4_filepath}"
    end

  end
end
