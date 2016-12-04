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
      adaptations = raw_adaptations.map{|adaptation| Abrizer::Adaptation.new(adaptation)}
      @adaptations = adaptations.select{|adaptation| adaptation.width <= @informer.width}
    end

    def ar_4_3_adaptations
      [
        {width: 256, height: 192, bitrate: "192k"},
        {width: 448, height: 336, bitrate: "400k"},
        {width: 640, height: 480, bitrate: "800k"},
        {width: 704, height: 528, bitrate: "1000k"},
      ]
    end

    def ar_16_9_adaptations
      # Average video bitrate from here: https://bitmovin.com/video-bitrate-streaming-hls-dash/
      [
        {width:  192, height: 108, bitrate: "200k"},
        {width:  426, height: 240, bitrate: "400k"},
        {width:  640, height: 360, bitrate: "800k"},
        {width:  854, height: 480, bitrate: "1.2M"},
        {width: 1280, height: 720, bitrate: "2.4M"},
        {width: 1920, height: 1080, bitrate: "4.8M"},
      ]
    end

  end
end
