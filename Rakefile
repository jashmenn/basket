require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require 'lib/ext/core'

GEM = "basket"
GEM_VERSION = "0.0.1"
AUTHOR = "Your Name"
EMAIL = "Your Email"
HOMEPAGE = "http://example.com"
SUMMARY = "A gem that provides..."

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.add_dependency('forkoff', '>= 0.0.1')
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(README.rdoc Rakefile) + Dir.glob("{lib,spec,examples,vendor}/**/*")
end

task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

namespace :rdoc do
  Rake::RDocTask.new :html do |rd|
     rd.main = "README.rdoc"
     rd.rdoc_dir = 'rdoc'
     rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  end
  task :open do
    system 'open ' + (:rdoc / 'index.html') if PLATFORM['darwin']
  end
end

desc "run rstakeout"
task :rstakeout do
  exec "AUTOTEST=true rstakeout -t 1 -v \"spec spec --format=specdoc --color\" '*/**/*.rb'"
end