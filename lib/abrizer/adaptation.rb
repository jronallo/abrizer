module Abrizer
  class Adaptation
    attr_reader :width, :height, :bitrate

    def initialize(width:, height:, bitrate:)
      @width = width
      @height = height
      @bitrate = bitrate
    end

    def ffmpeg_cmd(input)
      %Q|ffmpeg -y -i #{input} -vf \
          scale='#{width}:trunc(#{width}/dar/2)*2',setsar=1 \
          -an -c:v libx264 -x264opts 'keyint=24:min-keyint=24:no-scenecut' \
          -b:v #{bitrate} -maxrate #{bitrate} \
          -bufsize #{bitrate} \
          #{filepath(input)}|
    end

    def filepath(input)
      extname = File.extname input
      basename = File.basename input, extname
      name = "#{basename}/#{basename}-#{width}x#{height}-#{bitrate}.mp4"
      current_directory = File.dirname input
      File.join current_directory, name
    end

    def to_s
      "Width: #{@width}, Height: #{@height}, Bitrate: #{@bitrate}"
    end


  end
end
