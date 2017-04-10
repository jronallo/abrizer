module Abrizer
  class All

    def initialize(filename, output_dir, base_url, vp9=false)
      @filename = filename
      @output_directory = output_dir
      FileUtils.mkdir_p @output_directory
      @base_url = base_url
      @vp9 = vp9
    end

    def run
      Abrizer::FfprobeFile.new(@filename, @output_directory).run
      Abrizer::AdaptationsFile.new(nil, @output_directory).adaptations
      Abrizer::Captions.new(@filename, @output_directory).copy
      Abrizer::ProgressiveVp9.new(@filename, @output_directory).create if @vp9
      Abrizer::ProgressiveMp3.new(@filename, @output_directory).create
      Abrizer::Sprites.new(@filename, @output_directory).create
      Abrizer::TemporaryPoster.new(@output_directory).copy
      Abrizer::Processor.process(@filename, @output_directory)
      Abrizer::ProgressiveMp4.new(@output_directory).create
      Abrizer::PackageDashBento.new(@output_directory).package
      Abrizer::PackageHlsBento.new(@output_directory).package
      Abrizer::Canvas.new(nil, @output_directory, @base_url).create
      Abrizer::Data.new(nil, @output_directory, @base_url).create
      Abrizer::Cleaner.new(@output_directory).clean
    end

  end
end
