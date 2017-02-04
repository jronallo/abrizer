module Abrizer
  module FilepathHelpers
    def audio_filepath
      File.join output_directory, "#{basename}-audio.m4a"
    end

    def audio_filepath_fragmented
      File.join output_directory, "#{basename}-audio-frag.m4a"
    end

    def webvtt_input_filepath
      File.join filename_directory, "#{basename}.vtt"
    end

    def output_directory
      if @output_directory
        @output_directory
      else
        File.join filename_directory, basename
      end
    end

    def output_directory_basename
      File.basename output_directory
    end

    def filename_directory
      File.dirname @filename
    end

    # TODO: don't assume all incoming files will be .mp4
    def basename
      extname = File.extname @filename
      File.basename @filename, extname
    end

    def mpd_partial_filepath
      'fmp4/stream.mpd'
    end

    def mpd_filepath
      File.join output_directory, mpd_partial_filepath
    end

    def hlsts_partial_filepath
      'hls/master.m3u8'
    end

    def hlsts_filepath
      File.join output_directory, hlsts_partial_filepath
    end

    def mp4_partial_filepath
      'progressive.mp4'
    end

    def mp4_filepath
      File.join output_directory, mp4_partial_filepath
    end

    def vp9_partial_filepath
      'progressive-vp9.webm'
    end

    def vp9_filepath
      File.join output_directory, vp9_partial_filepath
    end

    def canvas_partial_filepath
      'canvas.json'
    end

    def canvas_filepath
      File.join output_directory, canvas_partial_filepath
    end

  end
end
