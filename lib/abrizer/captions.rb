module Abrizer
  # Copies over any WebVTT captions that are beside the original video resource
  # into the destination folder.
  # TODO: This may only be needed if fMP4 derivatives aren't created since
  # captions are copied over.
  class Captions

    include FilepathHelpers

    def initialize(filename, output_dir=nil)
      @filename = filename
      @output_directory = output_dir
      if vtt_dir_glob.length > 0
        FileUtils.mkdir_p vtt_output_directory
      end
    end

    def copy
      vtt_dir_glob.each do |vtt|
        vtt_basename = File.basename vtt
        vtt_filename = File.join vtt_output_directory, vtt_basename
        FileUtils.cp vtt, vtt_filename
      end
    end

    def vtt_dir_glob
      Dir.glob vtt_file_glob
    end

    def vtt_file_glob
      File.join filename_directory, "#{basename}*.vtt"
    end

    def vtt_output_directory
      File.join @output_directory, 'vtt'
    end

  end
end
