lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require 'columbus_cli/version'

Gem::Specification.new do |s|
  s.name        = 'columbus-cli'
  s.version     = ColumbusCli::VERSION
  s.summary     = 'Columbus CLI'
  s.description = 'Tools to use with Columbus Trackloggers'
  s.authors     = ['Aaron Ciaghi']
  s.email       = 'aaron.ciaghi@gmail.com'
  s.files       = Dir['bin/*', 'lib/**/*.rb']
  s.executables << 'columbus'
  s.homepage    = 'https://github.com/aaronsama/columbus-cli'
  s.license     = 'MIT'

  s.add_runtime_dependency 'gpx', '~> 0.8.2'
  s.add_runtime_dependency 'thor'

  s.add_development_dependency 'pry'
end
