module Abrizer
  class ProgressiveVp9

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
      @adaptation = adaptations.last
    end

    def bitrate
      @adaptation.bitrate
    end

    def ffmpeg_cmd
      "ffmpeg -y -i #{@filename} -c:v libvpx-vp9 -b:v #{bitrate}k -c:a libvorbis #{static_filepath}"
    end

    def static_filepath
      File.join output_directory, "progressive-vp9.webm"
    end


  end
end
