module Abrizer
  class FfmpegProcessor
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

    def audio_filepath
      File.join current_directory, "#{basename}/#{basename}-audio.m4a"
    end

    def output_directory
      File.join current_directory, basename
    end

    def current_directory
      File.dirname @filename
    end

    # TODO: don't assume all incoming files will be .mp4
    def basename
      extname = File.extname @filename
      File.basename @filename, extname
    end

  end
end
