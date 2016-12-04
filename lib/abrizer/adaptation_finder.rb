module Abrizer
  class AdaptationFinder
    attr_reader :adaptations
    def initialize(filename)
      @filename = filename
      find_adaptations
    end

    # TODO: analyze the incoming file and determine which preset to use
    def find_adaptations
      @adaptations = [
        Adaptation.new(width: 720, height: 480, bitrate: "1200k"),
        Adaptation.new(width: 576, height: 384, bitrate: "800k"),
        Adaptation.new(width: 432, height: 288, bitrate: "400k"),
        Adaptation.new(width: 216, height: 144, bitrate: "192k")
      ]
    end
  end
end
