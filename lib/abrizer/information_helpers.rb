module Abrizer
  module InformationHelpers

    # TODO: Could this be more flexible to potentially use a file
    # other than the mp4_filepath?
    def duration
      informer = Abrizer::FfprobeInformer.new(filepath: mp4_filepath, output_directory: @output_directory)
      informer.duration.to_f
    end

    def max_width
      @adaptations.last.width
    end

    def min_width
      @adaptations.first.width
    end

    def max_height
      @adaptations.last.height
    end

    def min_height
      @adaptations.first.height
    end

    def mp4_width
      @adaptations[-2].width
    end

    def mp4_height
      @adaptations[-2].height
    end

  end
end
