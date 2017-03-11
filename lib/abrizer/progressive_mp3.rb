module Abrizer
  class ProgressiveMp3

    include FilepathHelpers

    def initialize(filepath, output_directory)
      @filepath = filepath
      @output_directory = output_directory
    end

    def create
      `#{ffmpeg_cmd}`
    end

    def ffmpeg_cmd
      "ffmpeg -y -i #{@filepath} -vn -c:a libmp3lame -b:a 128k #{mp3_filepath}"
    end

  end
end
