# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth/mixi/version', __FILE__)

Gem::Specification.new do |s|
  s.name     = 'omniauth-mixi'
  s.version  = OmniAuth::Mixi::VERSION
  s.authors  = ['Mark Dodwell']
  s.email    = ['mark@mkdynamic.co.uk']
  s.summary  = 'Mixi strategy for OmniAuth'
  s.homepage = 'https://github.com/involver/omniauth-mixi'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.0.0'

  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_development_dependency 'rake'
end
