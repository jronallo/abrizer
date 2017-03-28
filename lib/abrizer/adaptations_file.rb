module Abrizer
  class AdaptationsFile

    include FilepathHelpers

    def initialize(filepath, output_directory)
      @filepath = filepath
      @output_directory = output_directory
    end

    def adaptations
      adapt = Abrizer::AdaptationFinder.new(@filepath).adaptations
      adapt_dump = adapt.map{|a| a.to_hash}
      File.open(adaptations_filepath, 'w') do |fh|
        fh.puts MultiJson.dump(adapt_dump)
      end
      adapt
    end
  end
end
