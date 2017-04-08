module Abrizer
  class FfprobeInformer

    include FilepathHelpers

    attr_reader :json_result, :info
    def initialize(filename, output_directory=nil)
      @filepath = filename
      @output_directory = output_directory
      get_info
    end

    def get_info
      if File.exist?(File.expand_path(@filepath)) && !File.directory?(@filepath)
        get_info_with_command
      elsif @output_directory && File.exist?(ffprobe_filepath)
        get_info_from_file
      else
        raise FfprobeError
      end
    end

    def get_info_from_file
      @json_result = File.read ffprobe_filepath
      @info = MultiJson.load @json_result
    end

    def get_info_with_command
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
      if probe_format && probe_format['duration']
        probe_format['duration']
      elsif video_stream && video_stream['duration']
        video_stream['duration']
      end
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

    def probe_format
      @info['format']
    end

    def audio_stream
      @info['streams'].find do |stream|
        stream['codec_type'] == 'audio'
      end
    end

    def ffmpeg_info_cmd
      "ffprobe -v error -print_format json -show_format -show_streams #{@filepath}"
    end

    def to_s
      ffmpeg_info_cmd + "\n" +
      "#{width}x#{height} DAR:#{display_aspect_ratio}"
    end

    def to_json
      information = @info
      info_filename = information['format']['filename']
      truncated_filename = File.basename info_filename
      information['format']['filename'] = truncated_filename
      MultiJson.dump information
    end

  end
end
