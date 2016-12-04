module Abrizer
  class FfmpegAdaptationCmdCreator
    def initialize(filename, adaptation)
      @filename = filename
      @adaptation = adaptation
    end

    def cmd
      %Q| ffmpeg -y -i #{@filename} -vf \
          scale=#{@adaptation.width}:#{@adaptation.height},setsar=1/1 \
          -an -c:v libx264 -x264opts 'keyint=24:min-keyint=24:no-scenecut' \
          -b:v #{@adaptation.bitrate} -maxrate #{@adaptation.bitrate} \
          -bufsize #{@adaptation.bitrate} \
          #{adaptation_filepath}|
    end

    def adaptation_filename
      "#{basename}-#{@adaptation.width}x#{@adaptation.height}-#{@adaptation.bitrate}.mp4"
    end

    def adaptation_filepath
      File.join current_directory, adaptation_filename
    end

    def current_directory
      File.dirname @filename
    end

    # TODO: don't assume all incoming files will be .mp4
    def basename
      File.basename @filename, '.mp4'
    end

  end
end
