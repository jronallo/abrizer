module Abrizer
  # Creates a IIIF Canvas JSON-LD document.
  class Canvas

    include FilepathHelpers

    # TODO: allow control of items/versions listed on canvas
    def initialize(filepath, output_directory, base_url)
      @filename = filename
      @output_directory = output_directory
      @base_url = base_url
    end

    def create
      puts create_json
      # TODO: save to file
    end

    def create_json
      Jbuilder.encode do |json|
        json.id canvas_id
        json.type "Canvas"
        json.width 2 #TODO width
        json.height 2 #TODO height
        json.duration 2 #TODO duration
        json.media do
          json.child! do
            json.type "Annotation"
            json.motivation 'painting'
            json.target canvas_id
            json.body do
              json.type "Choice"
              json.items do
                json.child! do
                  json.id mpd_id
                  json.type "Video"
                  json.format "application/dash+xml"
                end
                json.child! do
                  json.id hlsts_id
                  json.type "Video"
                  # TODO: or "vnd.apple.mpegURL"
                  json.format "application/x-mpegURL"
                end
                json.child! do
                  json.id vp9_id
                  json.type "Video"
                  #TODO: add mp4 codecs
                  json.format "video/webm"
                  json.width 2 #TODO width
                  json.height 2 #TODO height
                end
                json.child! do
                  json.id mp4_id
                  json.type "Video"
                  #TODO: add mp4 codecs
                  json.format "video/mp4"
                  json.width 2 #TODO width
                  json.height 2 #TODO height
                end
              end
              json.seeAlso do
                # Allow for adding more than one captions/subtitle file
                json.child! do
                  json.id vtt_id
                  json.format 'application/webvtt'
                  json.label 'English captions'
                  json.language 'en'
                  json._comments "How make explicit how whether to use these as captions or subtitles?"
                end
                json.child! do
                  json.id sprites_id
                  json.format 'application/webvtt'
                  json.label 'image sprite metadata'
                  json._comments "How to include resources like video image sprites like those created by https://github.com/jronallo/video_sprites and used by various players?"
                end
              end
            end
          end
        end
      end
    end

    def media_base_url
      File.join @base_url, output_directory_basename
    end

    def canvas_id
      File.join media_base_url, 'canvas.json'
    end

    def mpd_id
      File.join media_base_url, 'fmp4', 'stream.mpd'
    end

    def hlsts_id
      File.join media_base_url, 'hls', 'master.m3u8'
    end

    def mp4_id
      File.join media_base_url, 'progressive.mp4'
    end

    def vp9_id
      File.join media_base_url, 'progressive-vp9.webm'
    end

    def vtt_id
      File.join media_base_url, 'captions.vtt'
    end

    def sprites_id
      File.join media_base_url, 'sprites', 'sprites.vtt'
    end

  end
end
