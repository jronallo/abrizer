module Abrizer
  class FfmpegProcessor
    def initialize(filename)
      @filename = filename
      @output_directory = File.path(@filename)
      @adaptation_finder = Abrizer::AdaptationFinder.new(@filename)
    end

    def process
      process_videos
      process_audio
    end

    def process_videos
      @adaptation_finder.adaptations.each do |adaptation|
        `#{adaptation.ffmpeg_cmd(@filename)}`
      end
    end

    def process_audio
      audio_filepath = File.join current_directory, "#{basename}-audio.m4a"
      `ffmpeg -y -i #{@filename} -c:a libfdk_aac -b:a 128k -vn #{audio_filepath}`
    end

    def current_directory
      File.dirname @filename
    end

    # TODO: don't assume all incoming files will be .mp4
    def basename
      File.basename @filename, '.mp4'
    end

  end
end
