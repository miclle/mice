# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mice/version'
require 'rake'

Gem::Specification.new do |spec|
  spec.name          = "mice"
  spec.version       = Mice::VERSION
  spec.authors       = ["miclle"]
  spec.email         = ["miclle.zheng@gmail.com"]
  spec.summary       = "Front-end framework."
  spec.description   = "Mice is semantic front-end framework."
  spec.homepage      = "http://miclle.com"
  spec.license       = "MIT"

  spec.files         = FileList['lib/**/*.rb', '[A-Z]*', 'vendor/**/*'].to_a

  # spec.files         = `git ls-files -z`.split("\x0")
  # spec.files.reject! { |fn| fn.include? "docs" }

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  # spec.add_development_dependency "rake"
end
