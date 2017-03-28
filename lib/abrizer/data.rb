module Abrizer
  # Creates a JSON file with information about the videos
  class Data

    include FilepathHelpers
    include IdentifierHelpers
    include InformationHelpers

    def initialize(filepath, output_directory, base_url)
      # This is kind of hacky, but if the @output_directory is set then we can
      # use that to look up the vp9_filepath
      @output_directory = output_directory
      @base_url = base_url
      # Either we have a filepath to an original or we make the assumption we
      # really have an identifier instead of a filepath and we use that
      # identifier to look for an adaptations.json file. Failing finding the
      # adaptations.json file we just use the adaptations based on the
      # vp9_filepath.
      if File.exist?(File.expand_path(filepath)) && !File.directory?(filepath)
        @filename = filepath
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

    def find_adaptations
      finder = AdaptationFinder.new(@filename)
      @adaptations = finder.adaptations
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
        json.max_width max_width
        json.max_height max_height
        json.duration duration
        json.poster do
          poster(json)
        end
        json.video do
          mpd_source(json)
          hlsts_source(json)
          vp9_source(json)
          mp4_source(json)
        end
        json.audio do
          mp3_source(json)
          aac_source(json)
        end
        json.tracks do
          captions(json)
        end
        json.sprites do
          sprites(json)
        end
      end
    end

    def poster(json)
      if File.exist? poster_filepath
        json.child! do
          json.id poster_id
          json.format "image/jpg"
          json.width max_width
          json.height max_height
        end
      end
    end

    def mpd_source(json)
      if File.exist? mpd_filepath
        json.child! do
          json.id mpd_id
          json.format "application/dash+xml"
          json.width max_width
          json.height max_height
        end
      end
    end

    def hlsts_source(json)
      if File.exist? hlsts_filepath
        json.child! do
          json.id hlsts_id
          json.type "Video"
          # TODO: or "vnd.apple.mpegURL"
          json.format "application/x-mpegURL"
          json.width max_width
          json.height max_height
        end
      end
    end

    def vp9_source(json)
      if File.exist? vp9_filepath
        json.child! do
          json.id vp9_id
          json.type "Video"
          #TODO: add webm codecs
          json.format "video/webm"
          json.width max_width
          json.height max_height
        end
      end
    end

    def mp4_source(json)
      if File.exist? mp4_filepath
        json.child! do
          json.id mp4_id
          json.type "Video"
          #TODO: add mp4 codecs
          json.format "video/mp4"
          json.width mp4_width
          json.height mp4_height
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

    def captions(json)
      if File.exist? captions_filepath
        json.child! do
          json.id vtt_id
          json.format 'text/vtt'
          json.kind 'captions'
          json.label 'English captions'
          json.language 'en'
        end
      end
    end

    def sprites(json)
      if File.exist? sprites_filepath
        json.id sprites_id
        json.format 'text/vtt'
        json.kind 'metadata'
        json.label 'image sprite metadata'
      end
    end

  end
end
