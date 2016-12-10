module Abrizer
  class Adaptation
    attr_reader :width, :height, :bitrate

    def initialize(width:, height:, bitrate:)
      @width = width
      @height = height
      @bitrate = bitrate
    end

    def ffmpeg_cmd(input, pass)
      cmd = %Q|ffmpeg -y -i #{input} -vf \
          scale='#{width}:trunc(#{width}/dar/2)*2',setsar=1 \
          -an -c:v libx264 -x264opts 'keyint=48:min-keyint=48:no-scenecut' \
          -b:v #{bitrate} -preset faster |
      if pass == 2
        cmd += %Q| -maxrate #{bitrate} -bufsize #{bitrate} -pass 2 #{filepath(input)}|
      else
        cmd += " -pass 1 -f mp4 /dev/null "
      end
      cmd
    end

    def outfile_basename(input)
      extname = File.extname input
      basename = File.basename input, extname
      "#{basename}/#{basename}-#{width}x#{height}-#{bitrate}"
    end

    def filepath(input)
      name = "#{outfile_basename(input)}.mp4"
      current_directory = File.dirname input
      File.join current_directory, name
    end

    def filepath_fragmented(input)
      name = "#{outfile_basename(input)}-frag.mp4"
      current_directory = File.dirname input
      File.join current_directory, name
    end

    def to_s
      "Width: #{@width}, Height: #{@height}, Bitrate: #{@bitrate}"
    end


  end
end
