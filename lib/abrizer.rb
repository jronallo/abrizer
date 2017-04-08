require 'yajl'
require 'multi_json'
MultiJson.use :yajl
MultiJson.dump_options = {pretty: true}

require 'jbuilder'
require 'video_sprites'
require 'ostruct'

%w[
  version
  errors
  filepath_helpers
  read_adaptations
  debug_settings
  identifier_helpers
  information_helpers
  package_dash_shaka
  package_hls_shaka
  package_dash_bento
  package_hls_bento
  adaptation
  adaptation_finder
  adaptations_file
  ffmpeg_processor
  ffprobe_informer
  ffprobe_file
  processor
  cleaner
  progressive_mp4
  progressive_vp9
  progressive_mp3
  sprites
  captions
  canvas
  data
  temporary_poster
  all
].each do |dependency|
  require "abrizer/#{dependency}"
end


module Abrizer
  # Your code goes here...
end
