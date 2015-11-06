# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jekyll-prismic"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christoph Hochstrasser"]
  s.date = "2015-11-06"
  s.description = "    A Jekyll plugin for retrieving content from the Prismic.io API\n"
  s.email = ["me@christophh.net"]
  s.files = ["README.md", "LICENSE", "lib/jekyll", "lib/jekyll/prismic", "lib/jekyll/prismic/collection.rb", "lib/jekyll/prismic/drops.rb", "lib/jekyll/prismic/filters.rb", "lib/jekyll/prismic/generator.rb", "lib/jekyll/prismic/helper.rb", "lib/jekyll/prismic/hooks.rb", "lib/jekyll/prismic/site.rb", "lib/jekyll/prismic/version.rb", "lib/jekyll-prismic.rb"]
  s.homepage = "http://github.com/CHH/jekyll-prismic/"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Prismic.io integration for Jekyll"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<prismic.io>, ["~> 1.2"])
      s.add_runtime_dependency(%q<jekyll>, ["~> 3.0.0"])
    else
      s.add_dependency(%q<prismic.io>, ["~> 1.2"])
      s.add_dependency(%q<jekyll>, ["~> 3.0.0"])
    end
  else
    s.add_dependency(%q<prismic.io>, ["~> 1.2"])
    s.add_dependency(%q<jekyll>, ["~> 3.0.0"])
  end
end
