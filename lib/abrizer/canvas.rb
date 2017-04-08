module Abrizer
  # Creates a IIIF Canvas JSON-LD document.
  class Canvas

    include FilepathHelpers
    include IdentifierHelpers
    include InformationHelpers
    include ReadAdaptations

    # TODO: allow control of items/versions listed on canvas
    def initialize(filepath, output_directory, base_url)
      @filepath = filepath
      @output_directory = output_directory
      @base_url = base_url
      # finder = AdaptationFinder.new(@filename)
      # @adaptations = finder.adaptations
      read_adaptations
    end

    def create
      FileUtils.mkdir_p output_directory unless File.exist? output_directory
      File.open(canvas_filepath, 'w') do |fh|
        fh.puts create_json
      end
    end

    def create_json
      Jbuilder.encode do |json|
        json.set! '@context', 'http://iiif.io/api/presentation/3/context.json'
        json.id canvas_id
        json.type "Canvas"
        json.width max_width
        json.height max_height
        json.duration duration
        thumbnail_json(json)
        media_json(json) if media_content?
      end
    end

    def thumbnail_json(json)
      if File.exist? poster_image_filepath
        json.thumbnail do
          json.id poster_id
          json.type 'Image'
          json.format 'image/jpeg'
        end
      end
    end

    def media_content?
      all_media_paths.any? { |f| File.exist? f }
    end

    def media_json(json)
      json.content do
        json.child! do
          json.type "AnnotationPage"

          json.items do
            json.child! do
              json.type 'Annotation'
              json.motivation 'painting'
              json.target canvas_id
              json.body do
                json.child! do
                  json.type "Choice"
                  json.choiceHint 'client'
                  json.items do
                    mpd_item(json)
                    hlsts_item(json)
                    vp9_item(json)
                    mp4_item(json)
                    aac_item(json)
                  end
                end
                json.child! do
                  json.type 'Choice'
                  json.choiceHint 'client'
                  json.items do
                    captions_item(json)
                  end
                end
              end
            end
            sprites_item(json)
          end

        end
      end
    end

    def mpd_item(json)
      if File.exist? mpd_filepath
        json.child! do
          json.id mpd_id
          json.type "Video"
          json.format "application/dash+xml"
          json.width max_width
          json.height max_height
        end
      end
    end

    def hlsts_item(json)
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

    def vp9_item(json)
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

    def mp4_item(json)
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

    def aac_item(json)
      if File.exist? hlsts_aac_filepath
        json.child! do
          json.id hlsts_aac_id
          json.type "Audio"
          json.format 'audio/aac'
        end
      end
    end

    def captions_item(json)
      # TODO: update captions for multiple captions
      if File.exist? captions_filepath
        json.child! do
          json.id vtt_id
          json.type 'Text'
          json.format 'text/vtt'
          json.kind 'captions'
          json.label 'English captions'
          json.language 'en'
          json._comments "How make explicit how whether to use these as captions or subtitles, descriptions, or chapters?"
        end
      end
    end

    def sprites_item(json)
      if File.exist? sprites_filepath
        json.child! do
          json.type 'Annotation'
          json.motivation 'video-thumbnails'
          json.target canvas_id
          json.body do
            json.child! do
              json.id sprites_id
              json.type 'Text'
              json.format 'text/vtt'
              json.kind 'metadata'
              json.label 'image sprite metadata'
              json._comments "How to include resources like video image sprites like those created by https://github.com/jronallo/video_sprites and used by various players?"
            end
          end

        end
      end
    end

  end
end
