module Abrizer
  class Processor
    def self.process(filename, output_dir=nil)
      ffp = FfmpegProcessor.new(filename, output_dir)
      ffp.process
    end
  end
end
