# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'KindleCG/version'

Gem::Specification.new do |spec|
  spec.name          = "KindleCG"
  spec.version       = KindleCG::VERSION
  spec.authors       = ["Antonio Lorusso"]
  spec.email         = ["antonio.lorusso@gmail.com"]
  spec.description   = %q{Mirror your ebooks directory tree into kindle collections}
  spec.summary       = %q{kindlecg helps you manage your kindle collections using the filesystem directory tree}
  spec.homepage      = "http://antoniolorusso.com/KindleCG"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.18.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
