require 'rubygems'
require 'rake'
require 'yard'

namespace :yard do

  YARD::Rake::YardocTask.new(:isy) do |yardoc|
    yardoc.options <<
        '--protected' <<
        '--private' <<
        '--verbose' <<
        "--output-dir=./doc/yard/isy/" <<
        "--title=LocalYardoc"
    yardoc.files << './lib/isy/**/*.rb'
    yardoc.options << '--incremental' if File.exist? './.yardoc'
  end

  YARD::Rake::YardocTask.new(:app) do |yardoc|
    yardoc.options <<
        '--protected' <<
        '--private' <<
        '--verbose' <<
        "--output-dir=./doc/yard/app/" <<
        "--title=LocalYardoc"
    yardoc.files << './app/**/*.rb'
    yardoc.options << '--incremental' if File.exist? './.yardoc'
  end

  desc "clear yardoc"
  task :clear do
    FileUtils.rm_r ['./.yardoc', './doc/yard']
  end

end
