module Abrizer
  class FfprobeInformer
    attr_reader :json_result, :info
    def initialize(filename)
      @filename = filename
      get_info
    end

    def get_info
      @json_result = `#{ffmpeg_info_cmd}`
      @info = JSON.parse @json_result
    end

    def width
      video_stream['width'] if video_stream
    end

    def height
      video_stream['height'] if video_stream
    end

    def display_aspect_ratio #dar
      video_stream['display_aspect_ratio']
    end

    def video_stream
      @info['streams'].find do |stream|
        stream['codec_type'] == 'video'
      end
    end

    def audio_stream
      @info['streams'].find do |stream|
        stream['codec_type'] == 'audio'
      end
    end

    def ffmpeg_info_cmd
      "ffprobe -v error -print_format json -show_format -show_streams #{@filename}"
    end

    def to_s
      ffmpeg_info_cmd + "\n" +
      "#{width}x#{height} DAR:#{display_aspect_ratio}"
    end

  end
end
