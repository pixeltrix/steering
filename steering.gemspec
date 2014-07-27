# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "steering/version"

Gem::Specification.new do |gem|
  gem.name          = "steering"
  gem.version       = Steering::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ["Andrew White"]
  gem.email         = ["andyw@pixeltrix.co.uk"]
  gem.homepage      = "https://github.com/pixeltrix/steering"

  gem.summary       = %q{Ruby Handlebars.js Compiler}
  gem.description   = %q{Steering is a bridge to the official JavaScript Handlebars.js compiler.}

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'execjs', '>= 1.3.0'
  gem.add_runtime_dependency 'steering-source', '>= 1.3.0'
end
