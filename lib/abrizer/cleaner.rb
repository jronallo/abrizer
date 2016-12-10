module Abrizer
  class Cleaner

    include FilepathHelpers

    def initialize(filename, output_dir=nil)
      @filename = filename
      @output_directory = output_dir
      @adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
    end

    def clean
      delete_adaptations(@adaptations)
      clean_audio_file
      remove_pass1_log_files
    end

    def delete_adaptations(adapts)
      adapts.map do |adaptation|
        filepath = adaptation.filepath_fragmented(@filename, output_directory)
        FileUtils.rm filepath if File.exist? filepath
      end
    end

    def clean_audio_file
      FileUtils.rm audio_filepath_fragmented if File.exist? audio_filepath_fragmented
    end

    def remove_pass1_log_files
      glob = File.join output_directory, "ffmpeg2pass*"
      Dir.glob(glob).each do |log_filepath|
        FileUtils.rm log_filepath
      end
    end

  end
end
