module Abrizer
  class Sprites

    def initialize(filename, output_dir=nil)
      @filename = filename
      @output_directory = File.join output_dir, 'sprites'
      # TODO: make video sprites options configurable
      @options = {
        seconds: 10,
        width: 160,
        columns: 4,
        group: 20,
        gif: false,
        keep_images: true
      }
    end

    def create
      processor = VideoSprites::Processor.new(@filename, @output_directory, @options)
      processor.process
    end

  end
end
