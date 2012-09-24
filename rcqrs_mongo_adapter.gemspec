# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rcqrs_mongo_adapter/version"

Gem::Specification.new do |s|
  s.name        = "rcqrs_mongo_adapter"
  s.version     = RcqrsMongoAdapter::VERSION
  s.authors     = ["Tim de Putter"]
  s.email       = ["tim.de.putter83@googlemail.com"]
  s.summary     = %q{Adaptes rcqrs to mongodb}
  s.description = %q{Adaptes rcqrs to mongodb}

  s.rubyforge_project = "rcqrs_mongo_adapter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  s.add_runtime_dependency "rcqrs"
  s.add_runtime_dependency "activemodel"
  s.add_runtime_dependency "mongo"

  
end
