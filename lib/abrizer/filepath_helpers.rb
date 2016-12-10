module Abrizer
  module FilepathHelpers
    def audio_filepath
      File.join current_directory, "#{basename}/#{basename}-audio.m4a"
    end

    def audio_filepath_fragmented
      File.join current_directory, "#{basename}/#{basename}-audio-frag.m4a"
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
