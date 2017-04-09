module Abrizer
  class PackageHlsBento

    include FilepathHelpers

    def initialize(output_dir)
      @output_directory = output_dir
      @adaptations = Abrizer::AdaptationFinder.new(nil, @output_directory).adaptations
    end

    def package
      # Must change to output directory so this all works as intended
      Dir.chdir output_directory
      `#{bento_cmd}`
    end

    def video_inputs
      @adaptations.map do |adaptation|
        adaptation.filepath_fragmented(output_directory)
      end
    end

    def bento_cmd
      cmd = %Q|mp4hls --output-dir=hls --force --output-single-file |
      if webvtt_input_filepath && File.exist?(webvtt_input_filepath)
        cmd += %Q| [+format=webvtt,+language=eng]#{webvtt_input_filepath} |
      end
      cmd += %Q| #{video_inputs.join(' ')} [+language=eng]#{audio_filepath_fragmented} |
      puts cmd
      cmd
    end

  end
end
