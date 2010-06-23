require 'rubygems'
require 'rake'
require 'yard'

namespace :doc do

  namespace :yard do

    YARD::Rake::YardocTask.new(:local) do |yardoc|
      yardoc.options <<
          '--protected' <<
          '--private' <<
          '--verbose' <<
          "--output-dir=./doc/yard/" <<
          "--title=Isy Framework (local)"
      yardoc.files << './lib/**/*.rb'
      yardoc.options << '--incremental' if File.exist? './.yardoc'
    end

    desc "clear yardoc"
    task :clear do
      FileUtils.rm_r ['./.yardoc', './doc/yard']
    end

    YARD::Rake::YardocTask.new(:'gh-pages') do |yardoc|
      commit = `git log -n 1`
      hash = /^commit +(\w+)$/.match(commit)[1]
      yardoc.options <<
          '--protected' <<
          '--private' <<
          '--verbose' <<
          "--output-dir=./gh-pages/" <<
          "--title=Isy Framework | #{hash}"
      yardoc.files << './lib/**/*.rb' << '-' << 'MIT-LICENSE'
    end
  end
end
