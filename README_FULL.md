# Hammer

Ruby component based state-full web framework.

Framework is based on sinatra, eventmachine, em-websocket.

Goals:

- To make building rich web applications easy as possible.
- Fast application prototyping - smart building blocks.
- Speed.
- Concurrent request handling.
- Clean design - avoid unnecessary magic.
- Integrated server-side push actualizations.

## How to run example application

Clone repository

    git clone git://github.com/ruby-hammer/hammer.git

Install jeweler and install ruby-hammer gem

    gem install jeweler
    rake install

Move to examples directory

    cd examples

install bundler and run Bundler

    gem install bundler
    bundle install

use Ruby 1.9.(1|2) and run ruby-hammer

    hammer

use Chrome browser, it wont yet work in others. (It should work in Safari, but I didn't test it.)

There are some examples on [http://localhost:3000](http://localhost:3000) and real-time log on
[http://localhost:3000/#devel](http://localhost:3000/#devel)

### Chat

Test application - Chat is running on [http://pitr.sytes.net:3005/](http://pitr.sytes.net:3005/). It's really
a basic implementation. It does not have any persistent backend, messages are limited to 50 in each room and rooms are
dropped from memory after 4 hours of inactivity. You can login in each window as different person, nick and email
for gravatar is required.

### New name

''Ruby Hammer'' was selected.

## {file:docs/contribute How to Contribute}

## Discussions

are embedded with help of Google's wave. Anyone can read but to get write access you must be a member of
[http://groups.google.com/group/isy-framework](http://groups.google.com/group/isy-framework) and have account
on wave.google.com. Wave uses avatar as identification so please select one.

{file:docs/wave More to get you startet with wave.}

## Links

- Github: [http://github.com/ruby-hammer/hammer](http://github.com/ruby-hammer/hammer)
- Doc: [http://ruby-hammer.github.com/hammer/](http://ruby-hammer.github.com/hammer/)
- Pivotel Tracker: [http://www.pivotaltracker.com/projects/23639](http://www.pivotaltracker.com/projects/23639)
- License {file:MIT-LICENSE}

## Author

- Petr Chalupa

## Contributors
