require 'rubygems'
require 'rake'

begin
  require 'yard'

  options = %w[--protected --private --verbose --main=README_FULL.md]
  output = "--output-dir=./yardoc/"
  input = %w[./lib/**/*.rb - MIT-LICENSE README.md] + Dir.glob('docs/**/*')
  title = "--title=Ruby Hammer Framework"
  
  YARD::Rake::YardocTask.new(:yard) do |yardoc|
    yardoc.options.push(*options) << output << title
    yardoc.files.push(*input)
    yardoc.options << '--incremental' if File.exist? './.yardoc'
  end

  namespace :yard do

    YARD::Rake::YardocTask.new(:regenerate) do |yardoc|
      yardoc.options.push(*options) << output << title
      yardoc.files.push(*input)
    end

    YARD::Rake::YardocTask.new(:'gh-pages') do |yardoc|
      commit = `git log -n 1`
      hash = /^commit +(\w+)$/.match(commit)[1]
      yardoc.options.push(*options) <<
          "--output-dir=./gh-pages/" <<
          "--title=Ruby Hammer Framework | #{hash}"
          
      yardoc.files.push(*input)
    end
  end

rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "hammer"
    gem.summary = %Q{ruby component based state-full web framework}
    gem.description = %Q{ruby component based state-full web framework}
    gem.email = "hammer.framework@gmail.com"
    #    gem.homepage = "http://isy-pitr.github.com/isy-playground"
    gem.authors = ["Petr Chalupa"]

    gem.add_dependency 'uuid', ">= 0"
    gem.add_dependency 'tzinfo', '>= 0'
    gem.add_dependency 'i18n', '>= 0'
    gem.add_dependency 'activesupport', '>= 3.0.0.beta'
    gem.add_dependency 'erector', ">= 0.8.1"
    gem.add_dependency 'sinatra', ">= 1.0"
    gem.add_dependency 'thin', ">= 0"
    gem.add_dependency 'em-websocket', ">= 0"
    gem.add_dependency 'configliere', ">= 0"
    gem.add_dependency 'neverblock', ">= 0"
    gem.add_dependency 'bundler', ">= 0"

    gem.add_development_dependency "rspec", ">= 2.0.0.beta"
    gem.add_development_dependency "yard", ">= 0"
    #    gem.add_development_dependency "yard-rspec", ">= 0"
    gem.add_development_dependency "BlueCloth", ">= 0"
    gem.add_development_dependency "jeweler", ">= 0"
    gem.add_development_dependency "rack-test", ">= 0"

    gem.files = FileList['lib/**/*.*', 'examples/**/*.*'].to_a

    gem.test_files = FileList["spec/**/*.*"].to_a
    gem.extra_rdoc_files = FileList["README.md", "README_FULL.md", "MIT-LICENSE", 'docs/**/*.*'].to_a
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new 

  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.rcov = true
  end
rescue LoadError
  puts "misiing rspec/core/rake_task"
end