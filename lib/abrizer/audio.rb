module Abrizer
  class Audio

    include FilepathHelpers
    include DebugSettings

    def initialize(filename, output_dir, base_url)
      @filename = filename
      @output_directory = output_dir
      FileUtils.mkdir_p @output_directory
      @base_url = base_url
    end

    def run
      Abrizer::FfprobeFile.new(@filename, @output_directory).run
      make_directory
      Dir.chdir output_directory
      process_audio
      `#{bento_dash_cmd}`
      `#{bento_hls_cmd}`
      # Abrizer::Canvas.new(nil, @output_directory, @base_url).create
      Abrizer::DataAudio.new(@output_directory, @base_url).create
      clean_audio_file
    end

    # DRY up with ffmpeg_processor
    def make_directory
      FileUtils.mkdir_p output_directory unless File.exist? output_directory
    end

    # DRY up with ffmpeg_processor
    def process_audio
      `ffmpeg -y #{debug_settings} -i #{@filename} -c:a libfdk_aac -b:a 128k -vn #{audio_filepath}`
      `mp4fragment #{audio_filepath} #{audio_filepath_fragmented}`
      FileUtils.rm audio_filepath
    end

    def bento_dash_cmd
      cmd = %Q|mp4dash --output-dir=fmp4 --force --use-segment-template-number-padding --profiles=live --hls  [+language=eng]#{audio_filepath_fragmented} |
      puts cmd
      cmd
    end

    def bento_hls_cmd
      cmd = %Q|mp4hls --output-dir=hls --force [+language=eng]#{audio_filepath_fragmented} |
      puts cmd
      cmd
    end

    # DRY up with Cleaner#clean_audio_file
    def clean_audio_file
      FileUtils.rm audio_filepath_fragmented if File.exist? audio_filepath_fragmented
    end

  end
end
