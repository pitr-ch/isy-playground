require 'rubygems'
require 'rake'
require 'yard'

namespace :doc do

  options = %w[--protected --private --verbose --main=README_FULL.md]
  output = "--output-dir=./yardoc/"
  input = %w[./lib/**/*.rb - MIT-LICENSE README.md] + Dir.glob('docs/**/*')
  title = "--title=Isy Framework"
  
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
          "--title=Isy Framework | #{hash}"
          
      yardoc.files.push(*input)
    end
  end
end
