require 'thor'
module Abrizer
  class CLI < Thor

    desc 'process FILE', 'From mezzanine or preservation file create intermediary adaptations'
    def process(filename)
      Abrizer::Processor.process(filename)
    end

  end
end
