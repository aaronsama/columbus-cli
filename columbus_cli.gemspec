Gem::Specification.new do |s|
  s.name        = 'columbus-cli'
  s.version     = '0.1.2'
  s.date        = '2016-01-10'
  s.summary     = "Columbus CLI"
  s.description = "Tools to use with Columbus Trackloggers"
  s.authors     = ["Aaron Ciaghi"]
  s.email       = 'aaron.ciaghi@gmail.com'
  s.files       = ["lib/columbus_cli.rb", "lib/columbus_cli/track.rb"]
  s.executables << 'columbus'
  s.homepage    =
    'https://github.com/aaronsama/columbus-cli'
  s.license       = 'MIT'

  s.add_runtime_dependency 'gpx', '~> 0.8.2'
end
