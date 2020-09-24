# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jisx0402/version'

Gem::Specification.new do |spec|
  spec.name          = "jisx0402"
  spec.version       = Jisx0402::VERSION
  spec.authors       = ["cnosuke"]
  spec.email         = ["shinnosuke@gmail.com"]

  spec.summary       = 'Library for search District Code(全国地方公共団体コード, JIS X 0402) of Japan.'
  spec.homepage      = 'https://github.com/cnosuke/jisx0402'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "msgpack"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
