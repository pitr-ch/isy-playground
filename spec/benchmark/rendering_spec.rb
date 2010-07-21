# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'benchmark'
require 'ruby-prof'

describe 'Rendering Benchmar' do
  include IsyMocks

  before do
    @context = Isy::Core::Context.new('id', container_mock, 'devel')
    RubyProf.start
  end

  it do
    puts(Benchmark.measure do
        1000.times { $out = @context.to_html }
      end)
    puts $out
  end

  #  it do
  #    n = 100000
  #    Benchmark.bm(7) do |x|
  #      x.report("string") { str = ''; n.times { str << 'abc' }; str }
  #      x.report("array") { arr = []; n.times { arr << 'abc'}; arr.join }
  #      x.report("stringIO") { str = StringIO.new; n.times { str << 'abc'}; str.string }
  #    end
  #  end

  after do
    result = RubyProf.stop
    File.open('profile.html', 'w') do |f|
      RubyProf::GraphHtmlPrinter.new(result).print(f)
    end

    File.open('profile.txt', 'w') do |f|
      RubyProf::FlatPrinter.new(result).print(f)
    end
  end

  # jsonify callbacks 10_000.times
  # Rendering Benchmar
  #   15.510000   0.050000  15.560000 ( 15.615398)

  # callbacks
  # Rendering Benchmar
  #   14.520000   0.040000  14.560000 ( 15.262684)


end
