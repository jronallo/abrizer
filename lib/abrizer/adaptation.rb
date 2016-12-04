module Abrizer
  class Adaptation
    attr_reader :width, :height, :bitrate

    def initialize(width:, height:, bitrate:)
      @width = width
      @height = height
      @bitrate = bitrate
    end

    def ffmpeg_cmd(input)
      ffacc = FfmpegAdaptationCmdCreator.new(input, self)
      ffacc.cmd
    end

    def to_s
      "Width: #{@width}, Height: #{@height}, Bitrate: #{@bitrate}"
    end


  end
end
