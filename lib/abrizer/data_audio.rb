module Abrizer
  # Creates a JSON file with information about the videos
  class DataAudio

    include FilepathHelpers
    include IdentifierHelpers
    include InformationHelpers
    include ReadAdaptations

    def initialize(output_directory, base_url)
      @output_directory = output_directory
      @base_url = base_url
    end

    def create
      FileUtils.mkdir_p output_directory unless File.exist? output_directory
      File.open(data_filepath, 'w') do |fh|
        fh.puts create_json
      end
    end

    def create_json
      Jbuilder.encode do |json|
        json.id data_id
        json.duration duration
        json.audio do
          mpd_source(json)
          hlsts_source(json)
          mp3_source(json)
          aac_source(json)
        end
      end
    end

    def mpd_source(json)
      if File.exist? mpd_filepath
        json.child! do
          json.id mpd_id
          json.type "Audio"
          json.format "application/dash+xml"
        end
      end
    end

    def hlsts_source(json)
      if File.exist? hlsts_filepath
        json.child! do
          json.id hlsts_id
          json.type "Audio"
          # TODO: or "vnd.apple.mpegURL"
          json.format "application/x-mpegURL"
        end
      end
    end

    def mp3_source(json)
      if File.exist? mp3_filepath
        json.child! do
          json.id mp3_id
          json.format 'audio/mpeg'
        end
      end
    end

    def aac_source(json)
      if File.exist? hlsts_aac_filepath
        json.child! do
          json.id hlsts_aac_id
          json.format 'audio/aac'
        end
      end
    end

  end
end
