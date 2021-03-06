# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "stocktracker/version"

Gem::Specification.new do |s|
  s.name        = "stocktracker"
  s.version     = Stocktracker::VERSION
  s.authors     = ["Aaron Worsham"]
  s.email       = ["aaronworsham@gmail.com"]
  s.homepage    = "https://github.com/aaronworsham/stocktracker"
  s.summary     = %q{Returns Yahoo Finance Quotes for stock symbols.}
  s.description = %q{Queries Yahoo Finance for Quotes from current and past.  Uses Redis to cache results for period of time}

  s.rubyforge_project = "stocktracker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_runtime_dependency 'redis'
end
