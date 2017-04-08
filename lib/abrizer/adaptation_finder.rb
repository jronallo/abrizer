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
    def initialize(filename, output_dir=nil)
      @filename = filename
      @informer = Abrizer::FfprobeInformer.new(filename, output_dir)
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

    # The bitrates here are based on H.264 encoding.
    def ar_4_3_adaptations
      [
        {width: 224, height: 168, bitrate: 200},
        {width: 448, height: 336, bitrate: 400},
        {width: 640, height: 480, bitrate: 800},
        {width: 720, height: 540, bitrate: 1000},
      ]
    end

    # The bitrates here are based on H.264 encoding.
    def ar_16_9_adaptations
      # Average video bitrate from here: https://bitmovin.com/video-bitrate-streaming-hls-dash/
      [
        {width:  256, height: 144, bitrate: 200},
        {width:  512, height: 288, bitrate: 400},
        {width:  768, height: 432, bitrate: 800},
        {width: 1024, height: 576, bitrate: 1200},
        {width: 1280, height: 720, bitrate: 2400},
        {width: 1920, height: 1080, bitrate: 4800},
      ]
    end

  end
end
