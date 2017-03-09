module Abrizer
  module IdentifierHelpers

    def media_base_url
      File.join @base_url, output_directory_basename
    end

    def canvas_id
      File.join media_base_url, canvas_partial_filepath
    end

    def data_id
      File.join media_base_url, data_partial_filepath
    end

    def poster_id
      File.join media_base_url, poster_partial_filepath
    end

    def mpd_id
      File.join media_base_url, mpd_partial_filepath
    end

    def hlsts_id
      File.join media_base_url, hlsts_partial_filepath
    end

    def hlsts_aac_id
      File.join media_base_url, hlsts_aac_partial_filepath
    end

    def mp4_id
      File.join media_base_url, mp4_partial_filepath
    end

    def vp9_id
      File.join media_base_url, vp9_partial_filepath
    end

    def vtt_id
      File.join media_base_url, 'vtt/captions.vtt'
    end

    def sprites_id
      File.join media_base_url, sprites_partial_filepath
    end

  end
end
