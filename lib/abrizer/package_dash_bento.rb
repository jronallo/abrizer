module Abrizer
  class PackageDashBento

    include FilepathHelpers

    def initialize(filename, output_dir=nil)
      @filename = filename
      @output_directory = output_dir
      @adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
    end

    def package
      # Must change to output directory so this all works as intended
      Dir.chdir output_directory
      `#{bento_cmd}`
    end

    def video_inputs
      @adaptations.map do |adaptation|
        adaptation.filepath_fragmented(@filename, output_directory)
      end
    end

    def bento_cmd
      cmd = %Q|mp4dash --output-dir=fmp4 --force --use-segment-template-number-padding --profiles=live --hls |
      if File.exist? webvtt_input_filepath
        cmd += %Q| [+format=webvtt,+language=eng]#{webvtt_input_filepath} |
      end
      cmd += %Q| #{video_inputs.join(' ')} [+language=eng]#{audio_filepath_fragmented} |
      puts cmd
      cmd
    end

  end
end
