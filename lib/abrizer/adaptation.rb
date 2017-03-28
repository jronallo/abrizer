module Abrizer
  class Adaptation

    include FilepathHelpers
    include DebugSettings

    attr_reader :width, :height, :bitrate

    def initialize(width:, height:, bitrate:)
      @width = width
      @height = height
      @bitrate = bitrate
    end

    def ffmpeg_cmd(input, output_directory, pass)
      cmd = %Q|ffmpeg -y #{debug_settings} \
          -i #{input} -vf \
          yadif,scale='#{width}:trunc(#{width}/dar/2)*2',setsar=1 \
          -an -c:v libx264 -x264opts 'keyint=48:min-keyint=48:no-scenecut' \
          -b:v #{bitrate}k -preset faster -pix_fmt yuv420p |
      if pass == 2
        cmd += %Q| -maxrate #{constrained_bitrate}k -bufsize #{bitrate}k -pass 2 #{filepath(input, output_directory)} |
      else
        cmd += " -pass 1 -f mp4 /dev/null "
      end
      cmd
    end

    # TODO: make the constrained bitrate (maxrate) value configurable
    def constrained_bitrate
      @bitrate * 1.1
    end

    def outfile_basename(input)
      extname = File.extname input
      basename = File.basename input, extname
      "#{basename}-#{width}x#{height}-#{bitrate}"
    end

    def filepath(input, output_directory)
      name = "#{outfile_basename(input)}.mp4"
      File.join output_directory, name
    end

    def filepath_fragmented(input, output_directory)
      name = "#{outfile_basename(input)}-frag.mp4"
      File.join output_directory, name
    end

    def to_s
      "Width: #{@width}, Height: #{@height}, Bitrate: #{@bitrate}"
    end

    def to_json
      MultiJson.dump(to_hash)
    end

    def to_hash
      {width: @width, height: @height, bitrate: @bitrate}
    end

  end
end
