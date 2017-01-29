module Abrizer
  class All

    def initialize(filename, output_dir=nil)
      @filename = filename
      @output_directory = output_dir
    end

    def run
      Abrizer::Processor.process(@filename, @output_directory)
      Abrizer::ProgressiveMp4.new(@filename, @output_directory).create
      Abrizer::ProgressiveVp9.new(@filename, @output_directory).create
      Abrizer::PackageDashBento.new(@filename, @output_directory).package
      Abrizer::PackageHlsBento.new(@filename, @output_directory).package
      Abrizer::Sprites.new(@filename, @output_directory).create
      Abrizer::Cleaner.new(@filename, @output_directory).clean
    end

  end
end
