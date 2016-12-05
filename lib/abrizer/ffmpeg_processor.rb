module Abrizer
  class FfmpegProcessor

    include FilepathHelpers

    def initialize(filename)
      @filename = filename
      @output_directory = File.path(@filename)
      @adaptation_finder = Abrizer::AdaptationFinder.new(@filename)
    end

    def process
      make_directory
      process_videos
      process_audio
    end

    def make_directory
      FileUtils.mkdir output_directory unless File.exist? output_directory
    end

    def process_videos
      @adaptation_finder.adaptations.each do |adaptation|
        `#{adaptation.ffmpeg_cmd(@filename)}`
      end
    end

    def process_audio
      `ffmpeg -y -i #{@filename} -c:a libfdk_aac -b:a 128k -vn #{audio_filepath}`
    end

  end
end
