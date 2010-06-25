# How to contribute

## Code

* Use two spaces for indentation.
* Use four spaces for indentation of one line.
* Max line length is 120 chars.
* Use brackets in method definition.
* Use `{}` for one-line blocks and `do end` for multi-line.
* NetBeans are mostly used for developing so its formatter is considered as a guideline.
* Optimize for readability, not performance.

Short example of correct formating
    class Foo
      def method(*args)
        pp "something really long" +
            args.inspect

        user = User.new(arg1, arg2,
          :name => 'John',
          :age => 21
        )

        Users.all.map {|u| [u.name, u.age] }.select do |name, age|
          name > 'd' && age > 10
        end

        hash = {
          :key => :value
        }

      end
    end

## Repository

Structure is based on article [A successful Git branching model](ttp://nvie.com/git-model) with a modification that
in this repository `master` acts as `devel` and `stable` will act as `master` in the article.
(There is no `stable` yet, it will be after first release.)

## Test

Are done with [RSpec](http://rspec.info/) v2.0.0.beta 
([2.0 changes](http://github.com/rspec/rspec-core/blob/master/Upgrade.markdown)).
Framework is in its really early stages so there is no need to full coverage,
but if you write something don't try it in a console or a test application write some tests.

## Documentation

Is generated using [YARD](http://yardoc.org/) with [yard-rspec](http://rubygems.org/gems/yard-rspec) extension.
There are 3 Rake tasks:

* `yard` generates incrementally local documentation into `yardoc`
* `yard:regenerate` force to regenerate whole local documentation
* `yard:gh-pages` generates documentation into subdirectory `gh-pages` where clone of branch `gh-pages` is expected.
  It's used to update online documentation on
  [http://isy-pitr.github.com/isy-playground/](http://isy-pitr.github.com/isy-playground/)

## [Discussion](https://wave.google.com/wave/waveref/googlewave.com/w+7z-HD1_8D)

<div id="waveframe" style="width:100%; height:700px;"></div>
<script src="http://www.google.com/jsapi"></script>
<script type="text/javascript">
google.load("wave", "1");
google.setOnLoadCallback(function() { 
new google.wave.WavePanel({ target: document.getElementById("waveframe") }).loadWave("googlewave.com!w+7z-HD1_8D");});
</script>