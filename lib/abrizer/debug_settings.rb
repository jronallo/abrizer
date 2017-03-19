module Abrizer
  module DebugSettings

    # This is useful for testing an encoding setting on just part of a video.
    # This gets applied before the input video is set.
    def debug_settings
      ENV['ABRIZER_DEBUG_SETTINGS'] || ''
      # "-ss 10 -t 10"
    end
  end
end
