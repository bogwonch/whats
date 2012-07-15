# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','whats_version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'whats'
  s.version = Whats::VERSION
  s.author = 'Bogwonch'
  s.email = 'bogwonch@bogwonch.net'
  s.homepage = 'http://bogwonch.net'
  s.platform = Gem::Platform::RUBY
  s.summary = "Find out what something is, via DuckDuckGo's Zero Click Info"
  s.description = "Finds out what something is, via DuckDuckGo's Zero Click Info"
# Add your other files here if you make them
  s.files = %w(
bin/whats
lib/whats.rb
lib/whats_version.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','whats.rdoc']
  s.rdoc_options << '--title' << 'whats' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'whats'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
end
