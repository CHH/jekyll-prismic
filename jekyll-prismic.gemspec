$:.unshift(File.expand_path("../lib", __FILE__))
require "jekyll/prismic/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Prismic::VERSION
  spec.homepage = "http://github.com/CHH/jekyll-prismic/"
  spec.authors = ["Christoph Hochstrasser"]
  spec.email = ["me@christophh.net"]
  spec.files = %W(README.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "Prismic.io integration for Jekyll"
  spec.name = "jekyll-prismic"
  spec.license = "MIT"
  spec.has_rdoc = false
  spec.require_paths = ["lib"]
  spec.description =   spec.description   = <<-DESC
    A Jekyll plugin for retrieving content from the Prismic.io API
  DESC

  spec.add_runtime_dependency("prismic.io", "~> 1.2")
  spec.add_runtime_dependency("jekyll", "~> 3.0.0")
end
