module Abrizer
  class PackageHlsBento

    include FilepathHelpers

    def initialize(filename)
      @filename = filename
      @adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
    end

    def package
      # Must change to output directory so this all works as intended
      Dir.chdir output_directory
      `#{bento_cmd}`
    end

    def video_inputs
      @adaptations.map do |adaptation|
        adaptation.filepath_fragmented(@filename)
      end
    end

    def bento_cmd
      %Q|mp4hls --output-dir=hls --force --output-single-file #{video_inputs.join(' ')} [+language=eng]#{audio_filepath_fragmented}|
    end

  end
end
