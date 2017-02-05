module Abrizer
  # Creates a IIIF Canvas JSON-LD document.
  class Canvas

    include FilepathHelpers

    # TODO: allow control of items/versions listed on canvas
    def initialize(filepath, output_directory, base_url)
      @filename = filepath
      @output_directory = output_directory
      @base_url = base_url
      finder = AdaptationFinder.new(@filename)
      @adaptations = finder.adaptations
    end

    def create
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
        media_json(json)
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

    def media_json(json)
      json.media do
        json.child! do
          json.type "Annotation"
          json.motivation 'painting'
          json.target canvas_id
          json.body do
            json.type "Choice"
            json.items do
              mpd_item(json)
              hlsts_item(json)
              vp9_item(json)
              mp4_item(json)
            end
            json.seeAlso do
              # TODO: Allow for adding more than one captions/subtitle file
              captions_seealso(json)
              sprites_seealso(json)
            end
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

    def captions_seealso(json)
      # TODO: update captions seeAlso for multiple captions
      captions_file = File.join output_directory, 'vtt/captions.vtt'
      if File.exist? captions_file
        json.child! do
          json.id vtt_id
          json.format 'application/webvtt'
          json.label 'English captions'
          json.language 'en'
          json._comments "How make explicit how whether to use these as captions or subtitles, descriptions, or chapters?"
        end
      end
    end

    def sprites_seealso(json)
      if File.exist? sprites_filepath
        json.child! do
          json.id sprites_id
          json.format 'application/webvtt'
          json.label 'image sprite metadata'
          json._comments "How to include resources like video image sprites like those created by https://github.com/jronallo/video_sprites and used by various players?"
        end
      end
    end

    def media_base_url
      File.join @base_url, output_directory_basename
    end

    def canvas_id
      File.join media_base_url, canvas_partial_filepath
    end

    def poster_id
      File.join media_base_url, poster_partial_filepath
    end

    def mpd_id
      File.join media_base_url, mpd_partial_filepath
    end

    def hlsts_id
      File.join media_base_url, hlsts_partial_filepath
    end

    def mp4_id
      File.join media_base_url, mp4_partial_filepath
    end

    def vp9_id
      File.join media_base_url, vp9_partial_filepath
    end

    def vtt_id
      File.join media_base_url, 'vtt/captions.vtt'
    end

    def sprites_id
      File.join media_base_url, sprites_partial_filepath
    end

    def duration
      informer = Abrizer::FfprobeInformer.new(mp4_filename)
      informer.duration.to_f
    end

    def max_width
      @adaptations.last.width
    end

    def min_width
      @adaptations.first.width
    end

    def max_height
      @adaptations.last.height
    end

    def min_height
      @adaptations.first.height
    end

    def mp4_width
      @adaptations[-2].width
    end

    def mp4_height
      @adaptations[-2].height
    end

    # TODO: DRY up with progressive_mp4.rb
    def mp4_filename
      File.join output_directory, "progressive.mp4"
    end

  end
end
