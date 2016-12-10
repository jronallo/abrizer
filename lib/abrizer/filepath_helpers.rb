module Abrizer
  module FilepathHelpers
    def audio_filepath
      File.join output_directory, "#{basename}-audio.m4a"
    end

    def audio_filepath_fragmented
      File.join output_directory, "#{basename}-audio-frag.m4a"
    end

    def webvtt_input_filepath
      File.join output_directory, "#{basename}.vtt"
    end

    def output_directory
      if @output_directory
        @output_directory
      else
        File.join filename_directory, basename
      end
    end

    def filename_directory
      File.dirname @filename
    end

    # TODO: don't assume all incoming files will be .mp4
    def basename
      extname = File.extname @filename
      File.basename @filename, extname
    end
  end
end
