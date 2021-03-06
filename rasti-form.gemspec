Gem::Specification.new do |spec|
  spec.name          = 'rasti-form'
  spec.version       = '3.1.2'
  spec.authors       = ['Gabriel Naiman']
  spec.email         = ['gabynaiman@gmail.com']
  spec.summary       = 'Forms validations and type casting'
  spec.description   = 'Forms validations and type casting'
  spec.homepage      = 'https://github.com/gabynaiman/rasti-form'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'multi_require', '~> 1.0'
  spec.add_runtime_dependency 'rasti-model', '~> 1.0'

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'minitest', '~> 5.0', '< 5.11'
  spec.add_development_dependency 'minitest-colorin', '~> 0.1'
  spec.add_development_dependency 'minitest-line', '~> 0.6'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'pry-nav', '~> 0.2'

  if RUBY_VERSION < '2'
    spec.add_development_dependency 'term-ansicolor', '~> 1.3.0'
    spec.add_development_dependency 'tins', '~> 1.6.0'
    spec.add_development_dependency 'json', '~> 1.8'
  end
end
