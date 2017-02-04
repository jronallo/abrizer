# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'abrizer/version'

Gem::Specification.new do |spec|
  spec.name          = "abrizer"
  spec.version       = Abrizer::VERSION
  spec.authors       = ["Jason Ronallo"]
  spec.email         = ["jronallo@gmail.com"]

  spec.summary       = %q{Creates MPEG-DASH and HLS streams from a video file.}
  spec.description   = %q{Creates adaptive bitrate streams and other delivery derivatives.}
  spec.homepage      = "https://github.com/jronallo/abrizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "colorize"
  spec.add_development_dependency "bundler-audit"

  spec.add_dependency "thor"
  spec.add_dependency 'video_sprites', '0.2.0'
  spec.add_dependency 'jbuilder'
  spec.add_dependency 'yajl-ruby'
end
