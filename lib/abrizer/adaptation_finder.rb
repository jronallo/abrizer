module Abrizer
  # TODO: AdaptationFinder is incomplete. Basically what we want to do is to
  # find out the height, width, and aspect ratio of the original and then
  # determine which adaptations to create. So for a 3:2 video we'll have 4
  # adaptations but ought to only create ones that are the same size and smaller
  # than the input file. Adaptations that are larger should not be created.
  # So first we find the aspect ratio to see the value adaptations we could
  # apply and then we select the ones that are the same width and smaller.
  # If there is not an exact match for the
  # All of the aspect ratios here are given based on real files that have come
  # through our workflow, so there might be some missing.
  class AdaptationFinder
    attr_reader :adaptations, :info
    def initialize(filename)
      @filename = filename
      @informer = Abrizer::FfprobeInformer.new(filename)
      find_adaptations
    end

    # TODO: analyze the incoming file and determine which preset to use
    def find_adaptations
      raw_adaptations = case @informer.display_aspect_ratio
      when "4:3"
        ar_4_3_adaptations
      when "16:9"
        ar_16_9_adaptations
      else
        puts "Unable to find appropriate adaptation set!"
        exit
      end
      @adaptations = raw_adaptations.map{|adaptation| Abrizer::Adaptation.new(adaptation)}
    end

    def ar_4_3_adaptations
      [
        {width: 704, height: 528, bitrate: "1000k"},
        {width: 640, height: 480, bitrate: "800k"},
        {width: 576, height: 432, bitrate: "600k"},
        {width: 448, height: 336, bitrate: "400k"},
        {width: 256, height: 192, bitrate: "192k"}
      ]
    end

    def ar_16_9_adaptations
      [
        {width: 1280, height: 720, bitrate: ""},
        {width: 1024, height: 576, bitrate: ""},
        {width:  768, height: 432, bitrate: ""},
        {width:  512, height: 288, bitrate: ""},
        {width:  256, height: 144, bitrate: ""}
      ]
    end

  end
end
