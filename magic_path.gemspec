# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magic_path/version'

Gem::Specification.new do |spec|
  spec.name          = 'magic_path'
  spec.version       = MagicPath::VERSION
  spec.authors       = ['Donavan Stanley']
  spec.email         = ['donavan.stanley@gmail.com']

  spec.summary       = 'A gem for managing dynamic path names.'
  spec.description   = 'Uses Nenv and Facets under the covers.'
  spec.homepage      = 'https://github.com/Donavan/magic_path'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-byebug', '~> 3.4'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'facets', '~> 3.1'
  spec.add_dependency 'nenv', '~> 0.3'
end
