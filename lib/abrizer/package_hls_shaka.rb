module Abrizer
  class PackageHlsShaka

    include FilepathHelpers

    def initialize(filename, output_dir=nil)
      @filename = filename
      @adaptations = Abrizer::AdaptationFinder.new(@filename).adaptations
    end

    def package
      make_directory
      Dir.chdir hls_directory
      `#{shaka_cmd}`
    end

    def video_inputs
      @adaptations.map do |adaptation|
        filepath = adaptation.filepath(@filename)
        adaptation_basename = File.basename filepath, '.mp4'
        segment_template = "#{adaptation_basename}-$Number$.ts"
        adaptation_hls_playlist = "#{adaptation_basename}.m3u8"
        %Q|'input=#{filepath},stream=video,segment_template=#{segment_template},playlist_name=#{adaptation_hls_playlist}'|
      end
    end

    def audio_input
      hls_audio_filename = "#{basename}-audio-$Number$.ts"
      hls_audio_playlist = "#{basename}-audio.m3u8"
      %Q| 'input=#{audio_filepath},stream=audio,segment_template=#{hls_audio_filename},playlist_name=#{hls_audio_playlist},hls_group_id=AUDIO,hls_name=ENGLISH' |
    end

    def mpd_filename
      File.join 'dash', "#{basename}.mpd"
    end

    def shaka_cmd
      %Q|shaka-packager #{video_inputs.join(' ')} #{audio_input} --single_segment=false --hls_master_playlist_output=#{basename}.m3u8|
    end

    def make_directory
      FileUtils.mkdir hls_directory unless File.exist? hls_directory
    end

    def hls_directory
      File.join output_directory, 'hls'
    end

  end
end
