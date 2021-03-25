Gem::Specification.new do |s|
  s.name          = 'logstash-filter-geojson-enrich-1'
  s.version       = '0.1.1'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Enriches documents with area name defined as geojson'
  s.authors       = ['Alexandru Peptan']
  s.email         = 'apeptan@siscale.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency 'logstash-core', '>= 1.4.0', '< 8.0.0'
  s.add_runtime_dependency 'rgeo', '>= 2.2.0'
  s.add_runtime_dependency 'rgeo-geojson', '>= 2.1.1'

  s.add_development_dependency 'logstash-devutils'
  
  s.requirements << "jar 'org.apache.logging.log4j:log4j-core', '2.6.2'"
  s.add_runtime_dependency 'jar-dependencies'
end
