module Abrizer
  # TODO: Allow MP3 to be created from the adaptation audio
  class ProgressiveMp3

    include FilepathHelpers
    include DebugSettings

    def initialize(filepath, output_directory)
      @filepath = filepath
      @output_directory = output_directory
    end

    def create
      `#{ffmpeg_cmd}`
    end

    def ffmpeg_cmd
      "ffmpeg -y #{debug_settings} -i #{@filepath} -vn -c:a libmp3lame -b:a 128k #{mp3_filepath}"
    end

  end
end
