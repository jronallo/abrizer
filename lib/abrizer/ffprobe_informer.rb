module Abrizer
  class FfprobeInformer
    attr_reader :json_result, :info
    def initialize(filename)
      @filename = filename
      get_info
    end

    def get_info
      @json_result = `#{ffmpeg_info_cmd}`
      @info = MultiJson.load @json_result
    end

    def width
      video_stream['width'] if video_stream
    end

    def height
      video_stream['height'] if video_stream
    end

    def duration
      video_stream['duration'] if video_stream
    end

    def display_aspect_ratio #dar
      dar = video_stream['display_aspect_ratio']
      sar = video_stream['sample_aspect_ratio']
      if dar == "0:1" #&& sar == "0:1"
        calculate_aspect_ratio_from_wh
      else
        dar
      end
    end

    def calculate_aspect_ratio_from_wh
      new_width = width
      new_height = height
      w = width
      h = height
      while h != 0
        rem = w % h
        w = h
        h = rem
      end
      new_height = new_height / w
      new_width = new_width / w
      "#{new_width}:#{new_height}"
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
