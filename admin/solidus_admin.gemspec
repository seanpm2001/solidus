# frozen_string_literal: true

require_relative '../core/lib/spree/core/version'
require_relative './lib/solidus_admin/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_admin'
  s.version     = SolidusAdmin::VERSION
  s.summary     = 'Admin interface for the Solidus e-commerce framework.'
  s.description = s.summary

  s.author      = 'Solidus Team'
  s.email       = 'contact@solidus.io'
  s.homepage    = 'http://solidus.io'
  s.license     = 'BSD-3-Clause'

  s.metadata['rubygems_mfa_required'] = 'true'

  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|script)/})
  end

  s.required_ruby_version = '>= 3.0.0'
  s.required_rubygems_version = '>= 1.8.23'

  s.add_dependency 'geared_pagination', '~> 1.1'
  s.add_dependency 'importmap-rails', '~> 1.2', '>= 1.2.1'
  s.add_dependency 'solidus_backend', '> 3'
  s.add_dependency 'solidus_core', '> 3'
  s.add_dependency 'stimulus-rails', '~> 1.2'
  s.add_dependency 'tailwindcss-rails', '~> 2.0'
  s.add_dependency 'turbo-rails', '~> 1.4'
  s.add_dependency 'view_component', '~> 3.3'
end
