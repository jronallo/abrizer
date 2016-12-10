module Abrizer
  class FfmpegProcessor

    include FilepathHelpers

    def initialize(filename)
      @filename = filename
      @output_directory = File.path(@filename)
      @adaptation_finder = Abrizer::AdaptationFinder.new(@filename)
    end

    def process
      make_directory
      Dir.chdir output_directory
      process_first_pass
      process_second_passes
      process_audio
    end

    def make_directory
      FileUtils.mkdir output_directory unless File.exist? output_directory
    end

    def first_pass_adaptation
      adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
      sorted = adaptations.sort_by do |adaptation|
       adaptation.width
      end
      sorted[-2]
    end

    def first_pass_cmd
      first_pass_adaptation.ffmpeg_cmd(@filename, 1)
    end

    def process_first_pass
      puts first_pass_cmd
      `#{first_pass_cmd}`
    end

    def process_second_passes
      @adaptation_finder.adaptations.each do |adaptation|
        cmd = adaptation.ffmpeg_cmd(@filename, 2)
        puts cmd
        `#{cmd}`
        `mp4fragment #{adaptation.filepath(@filename)} #{adaptation.filepath_fragmented(@filename)}`
        FileUtils.rm adaptation.filepath(@filename)
      end
    end

    def process_audio
      `ffmpeg -y -i #{@filename} -c:a libfdk_aac -b:a 128k -vn #{audio_filepath}`
      `mp4fragment #{audio_filepath} #{audio_filepath_fragmented}`
      FileUtils.rm audio_filepath
    end

  end
end
