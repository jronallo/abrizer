module Abrizer
  class AdaptationsFile

    include FilepathHelpers

    def initialize(filepath, output_directory)
      @filepath = filepath
      @output_directory = output_directory
      FileUtils.mkdir_p @output_directory unless File.exist? @output_directory
    end

    def adaptations
      adapt = Abrizer::AdaptationFinder.new(filepath: @filepath, output_directory: @output_directory).adaptations
      adapt_dump = adapt.map{|a| a.to_hash}
      File.open(adaptations_filepath, 'w') do |fh|
        fh.puts MultiJson.dump(adapt_dump)
      end
      adapt
    end
  end
end
