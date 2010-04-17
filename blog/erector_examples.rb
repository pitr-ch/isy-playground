require 'rubygems'
require 'active_support'
require 'erector'

class Email < Erector::Widget
  
  attr_reader :email

  def initialize(email)
    @email = email
    super()
  end
  
  def content
    a email, :href => "mailto:#{email}"
  end
end

class List < Erector::Widget

  attr_reader :items

  def initialize(items)
    @items = items
    super()
  end

  def content
    if items.blank?
      blank
    else
      list
    end
  end

  def list
    ul do
      items.each {|item| item item }
    end
  end

  def blank
  end

  def item(item)
    li { widget(item) }
  end
end

puts List.new(
  ['e1@example.com', 'e2@example.com'].
      map {|email| Email.new(email) }
).to_s(:prettyprint => true)

class Person < Erector::Widget
  attr_reader :name, :emails

  def initialize(name, emails = [])
    @name, @emails = name, emails
    super()
  end

  def content
    strong "#{name}: "
    widget List, emails.map {|email| Email.new(email) }
  end
end

puts List.new(
  [ Person.new('John Smith', ['john.smith@example.com', 'jsmith@example.com']),
    Person.new('Peter Smith', ['peter.smith@example.com']),
    Person.new('Thomas Smith')
  ]
).to_s(:prettyprint => true)

class Person
  class List < ::List
    def blank
      ul do
        li { text 'no emails'}
      end
    end
  end
end

puts List.new(
  [ Person.new('John Smith', ['john.smith@example.com', 'jsmith@example.com']),
    Person.new('Peter Smith', ['peter.smith@example.com']),
    Person.new('Thomas Smith')
  ]
).to_s(:prettyprint => true)
