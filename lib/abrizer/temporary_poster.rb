module Abrizer
  # It is usually better for a human to select a poster image, but we try to
  # select a temporary one.
  # Creating sprites leaves some images around so that is a prerequisite for
  # this step.
  # TODO: selection of a temporary poster image could be improved
  class TemporaryPoster

    include FilepathHelpers

    def initialize(output_dir)
      @output_directory = output_dir
    end

    def copy
      FileUtils.cp first_image_filepath, poster_image_filepath
      FileUtils.chmod "ugo+r", poster_image_filepath
    end

  end
end
