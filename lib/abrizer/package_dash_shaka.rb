module Abrizer
  class PackageDashShaka

    include FilepathHelpers

    def initialize(filename)
      @filename = filename
      @adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
    end

    def package
      make_directory
      Dir.chdir output_directory
      `#{shaka_cmd}`
    end

    def video_inputs
      @adaptations.map do |adaptation|
        filepath = adaptation.filepath(@filename)
        adaptation_basename = File.basename filepath, '.mp4'
        output_filename = File.join 'dash', "#{adaptation_basename}-dash.mp4"
        %Q|"input=#{filepath},stream=video,output=#{output_filename}"|
      end
    end

    def audio_input
      dash_audio_filename = File.join 'dash', "#{basename}-audio-dash.m4a"
      "input=#{audio_filepath},stream=audio,output=#{dash_audio_filename}"
    end

    def mpd_filename
      File.join 'dash', "#{basename}.mpd"
    end

    def shaka_cmd
      %Q|shaka-packager #{video_inputs.join(' ')} #{audio_input} --profile on-demand --mpd_output #{mpd_filename}|
    end

    def make_directory
      FileUtils.mkdir dash_directory unless File.exist? dash_directory
    end

    def dash_directory
      File.join output_directory, 'dash'
    end


  end
end
