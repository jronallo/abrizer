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
      FileUtils.chmod_R "go+r", @output_directory
      optimize_images
    end

    def optimize_images
      optimize_sprites
      optimize_individual_images
    end

    def optimize_sprites
      `jpegoptim #{sprite_paths.join(' ')}`
    end

    def sprite_paths
      Dir.glob(sprites_glob)
    end

    def sprites_glob
      File.join @output_directory, "*.jpg"
    end

    def optimize_individual_images
      `jpegoptim #{individual_image_paths.join(' ')}`
    end

    def individual_image_paths
      Dir.glob(individual_image_glob)
    end

    def individual_image_glob
      File.join @output_directory, "images/*.jpg"
    end

  end
end
