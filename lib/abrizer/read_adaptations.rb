module Abrizer
  module ReadAdaptations



    def read_adaptations
      # Either we have a filepath to an original or we make the assumption we
      # really have an identifier instead of a filepath and we use that
      # identifier to look for an adaptations.json file. Failing finding the
      # adaptations.json file we just use the adaptations based on the
      # vp9_filepath.
      if File.exist?(File.expand_path(@filepath)) && !File.directory?(@filepath)
        @filename = @filepath
        find_adaptations
      elsif File.exist? adaptations_filepath
        # assume we have an identifier and look up for the adaptations file
        adaptations_json = File.read adaptations_filepath
        adaptations = MultiJson.load adaptations_json
        # TODO: There ought to be a class that recreates an Adaptation instance
        # based on the adaptations.json file. For now we fake it with a
        # OpenStruct.
        @adaptations = adaptations.map do |a|
          OpenStruct.new(a)
        end
      elsif File.exist? vp9_filepath
        # assume we just got an identifier and look for the webm
        @filename = vp9_filepath
        find_adaptations
      else
        raise "Neither original file or VP9 version exist."
      end
    end
  end
end
