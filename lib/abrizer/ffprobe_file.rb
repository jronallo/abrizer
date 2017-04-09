module Abrizer
  class FfprobeFile

    include FilepathHelpers

    def initialize(filename, output_directory)
      @informer = FfprobeInformer.new(filename)
      @output_directory = output_directory
      FileUtils.mkdir_p @output_directory unless File.exist? @output_directory
    end

    def run
      File.open(ffprobe_filepath, 'w') do |fh|
        fh.puts @informer.to_json
      end
    end
  end
end
