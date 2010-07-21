files = %w[
  examples/counter.rb
  examples/base.rb
  examples/ask/base.rb
  examples/ask/counter.rb
  examples/counters/base.rb
  examples/counters/counter.rb
  examples/form/base.rb
  app_layout.rb
]

files.each {|f| require "./#{f}" }