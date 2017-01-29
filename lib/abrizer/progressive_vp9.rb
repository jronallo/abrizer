module Abrizer
  class ProgressiveVp9

    include FilepathHelpers

    def initialize(filename, output_dir=nil)
      @filename = filename
      @output_directory = output_dir
      make_directory
      Dir.chdir @output_directory
      find_adaptation
    end

    def create
      `#{ffmpeg_cmd_pass1}`
      `#{ffmpeg_cmd_pass2}`
    end

    def make_directory
      FileUtils.mkdir @output_directory unless File.exist? @output_directory
    end

    def find_adaptation
      adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
      sorted = adaptations.sort_by do |adaptation|
        adaptation.width
      end
      @adaptation = sorted.last
    end

    # Since we are using the VP9 as a fallback we use half the bitrate
    # we would use for an MP4 encode.
    def bitrate
      @adaptation.bitrate/2
    end

    def ffmpeg_cmd_pass1
      "ffmpeg -y -i #{@filename} -c:v libvpx-vp9 -b:v #{bitrate}k -c:a libvorbis \
       -vf scale='#{@adaptation.width}:trunc(#{@adaptation.width}/dar/2)*2',setsar=1 \
       -speed 4 -tile-columns 6 -frame-parallel 1 \
       -pass 1 -passlogfile ffmpeg2pass-webm -f webm /dev/null"
    end

    def ffmpeg_cmd_pass2
      "ffmpeg -y -i #{@filename} -c:v libvpx-vp9 -b:v #{bitrate}k -c:a libvorbis \
       -vf scale='#{@adaptation.width}:trunc(#{@adaptation.width}/dar/2)*2',setsar=1 \
       -speed 1 -tile-columns 6 -frame-parallel 1 -auto-alt-ref 1 -lag-in-frames 25 \
       -pass 2 -passlogfile ffmpeg2pass-webm -y #{static_filepath}"
    end

    def static_filepath
      File.join output_directory, "progressive-vp9.webm"
    end


  end
end
