# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','web_version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'web'
  s.version = Web::VERSION
  s.author = 'Venkat Dinavahi'
  s.email = 'vendiddy@gmail.com'
  s.homepage = 'http://google.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A toolbelt for web developesr'
# Add your other files here if you make them
  s.files = %w(
    bin/web
    lib/web_version.rb
    lib/mysql.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','web.rdoc']
  s.rdoc_options << '--title' << 'web' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'web'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_runtime_dependency('gli')
  s.add_runtime_dependency('configliere')
end
