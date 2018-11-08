# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'actionset'
  spec.version       = '0.6.0'
  spec.authors       = ['Stephen Margheim']
  spec.email         = ['stephen.margheim@gmail.com']

  spec.summary       = 'A toolkit to wire-up ActiveSet collections with a Rails controller.'
  spec.description   = 'Easily filter, sort, and paginate enumerable sets via web requests.'
  spec.homepage      = 'https://github.com/fractaledmind/actionset'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activeset', '>= 0.6.0'
  spec.add_dependency 'activesupport', '>= 4.0.2'
  spec.add_dependency 'railties'

  spec.add_development_dependency 'rails', '~> 5.1.0'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'combustion'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-console'
end
