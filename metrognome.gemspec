# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
require 'metrognome/version'

Gem::Specification.new do |gem|
  gem.name          = "metrognome"
  gem.version       = Metrognome::VERSION
  gem.authors       = ["Chris Carlon"]
  gem.email         = ["chris.carlon25@gmail.com"]
  gem.description   = %q{A simple repeating task scheduler for Rails applications}
  gem.summary       = %q{A simple repeating task scheduler for Rails applications}
  gem.homepage      = "https://github.com/cjc25/metrognome"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
