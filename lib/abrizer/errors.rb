module Abrizer

  # This error is raised if Abrizer::ReadAdaptations is unable to determine
  # the adaptations that have or will be created for a given mezzanine file.
  class ReadAdaptationsError < StandardError
    def initialize
      msg = "Unable to read adaptations. Either inlude the path to a master file or an identifier. If passing just the identifier you must have created an adaptations.json file to read in or as a final fallback have already created a VP9 derivative."
      super(msg)
    end
  end

  class FfprobeError < StandardError
    def initialize
      msg = "Unable to find file to run ffprobe on or unable to read in ffprobe.json file."
      super(msg)
    end
  end

  class Mp4AdaptationNotFoundError < StandardError
    def initialize
      msg = "The fragmented adaptation used to create the progressive MP4 access derivative was not found. You must run `process` before this."
    end
  end

end
