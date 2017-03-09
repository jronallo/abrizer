module Abrizer
  module InformationHelpers

    def duration
      informer = Abrizer::FfprobeInformer.new(mp4_filepath)
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
