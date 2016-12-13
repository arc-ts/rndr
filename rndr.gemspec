# -*- encoding: utf-8 -*-
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rndr/version'

Gem::Specification.new do |gem|
  gem.name            = 'rndr'
  gem.version         = Rndr::VERSION
  gem.authors         = ['Bob Killen']
  gem.homepage        = 'https://github.com/arc-ts/rndr'
  gem.email           = ['arcts-dev@umich.edu']
  gem.license         = 'MIT'
  gem.summary         = 'Render Ruby templates quickly and easily.'
  gem.description     = 'rndr is a tool that simply renders Ruby erb ' \
                        'templates for use with other applications.'
  gem.files           = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables     = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.require_paths   = ['lib']

  gem.required_ruby_version = '>= 2.3'

  gem.add_dependency 'deep_merge', '~> 1.1'
  gem.add_dependency 'thor', '~> 0.19'

  gem.add_development_dependency 'bundler', '~> 1.12'
  gem.add_development_dependency 'rake', '~> 11.2'
  gem.add_development_dependency 'rspec', '~> 3.5'
  gem.add_development_dependency 'coveralls', '~> 0.8'
end
