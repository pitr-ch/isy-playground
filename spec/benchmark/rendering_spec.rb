# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'benchmark'
require 'ruby-prof'

require 'nokogiri'
require 'ruby-prof'

module NokogiriBackend

  def __element__(raw, tag_name, *args, &block)
    #    puts '-', args.inspect
    attributes = args.extract_options!
    value = args.pop
    #    puts tag_name.inspect, attributes.inspect, value.inspect, block.inspect
    output.__send__(tag_name, attributes) { (value && text(value)) || block.call }
  end

  def __empty_element__(tag_name, attributes={})
    output.__send__ tag_name, attributes
  end

  def _render(options = {}, &block)
    @_block   = block if block
    @_parent  = options[:parent]  || parent
    @_helpers = options[:helpers] || parent
    @_output  = options[:output]
    @_output  = Nokogiri::HTML::Builder.new unless output

    #      output.widgets << self.class
    send(options[:content_method_name] || :content)
    output
  end

  def to_html(options = {})
    _render(options).to_html
  end
end

describe 'Rendering Benchmar' do
  include IsyMocks

  before do
    @context = Isy::Core::Context.new('id', container_mock, 'devel')
    RubyProf.start
  end

  NUM = 1_000

  it do
    Benchmark.bm(7) do |x|
      x.report("normal")  { 
        #        RubyProf.resume {
        NUM.times { $out = @context.to_html }
        #        }
      }
    end
    puts $out
  end

  it do
    Benchmark.bm(7) do |x|
      Isy::Widget::Base.send :include, NokogiriBackend
      x.report("nokorigi") { 
        #        RubyProf.resume {
        NUM.times { $out = @context.to_html }
        #        }
      }
    end
    puts $out
  end

  after do
    result = RubyProf.stop

    File.open 'profile.html', 'w' do |f|
      RubyProf::GraphHtmlPrinter.new(result).print(f)
    end

    File.open('profile.txt', 'w') do |f|
      RubyProf::FlatPrinter.new(result).print(f)
    end
  end
  
  #  it do
  #    n = 100000
  #    Benchmark.bm(7) do |x|
  #      x.report("string") { str = ''; n.times { str << 'abc' }; str }
  #      x.report("array") { arr = []; n.times { arr << 'abc'}; arr.join }
  #      x.report("stringIO") { str = StringIO.new; n.times { str << 'abc'}; str.string }
  #    end
  #  end

  # jsonify callbacks 10_000.times
  # Rendering Benchmar
  #   15.510000   0.050000  15.560000 ( 15.615398)

  # callbacks
  # Rendering Benchmar
  #   14.520000   0.040000  14.560000 ( 15.262684)


end
