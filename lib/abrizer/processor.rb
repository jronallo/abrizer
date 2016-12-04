module Abrizer
  class Processor
    def self.process(filename)
      ffp = FfmpegProcessor.new(filename)
      ffp.process
    end
  end
end
