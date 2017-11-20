lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stenciljs/version"

Gem::Specification.new do |spec|
  spec.name          = "stenciljs"
  spec.version       = StencilJS::VERSION
  spec.authors       = ["Yuki Nishijima"]
  spec.email         = ["yk.nishijima@gmail.com"]
  spec.summary       = %q{Stencil.js on Rails}
  spec.description   = %q{The stenciljs gem provides useful helpers, tasks, and generators For Stencil.js.}
  spec.homepage      = "https://github.com/yuki24/stenciljs-gem"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties",      ">= 4.0"
  spec.add_dependency "activesupport", ">= 4.0"

  spec.add_development_dependency "bundler",  "~> 1.16"
  spec.add_development_dependency "rake",     "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
