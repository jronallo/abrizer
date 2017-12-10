module Abrizer
  class Waveform

    include FilepathHelpers
    include DebugSettings

    def initialize(filename, output_dir)
      @filename = filename
      @output_directory = File.join output_dir
      make_directory
    end

    def create
      `#{audiowaveform_cmd}`
    end

    def audiowaveform_cmd
      "audiowaveform -i #{@filename} -o #{waveform_filepath} -z 256"
    end

    def make_directory
      FileUtils.mkdir_p waveform_directory unless File.exist? waveform_directory
    end

  end
end
