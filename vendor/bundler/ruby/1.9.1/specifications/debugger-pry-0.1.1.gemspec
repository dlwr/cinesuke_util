# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "debugger-pry"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew O'Brien", "John Mair"]
  s.date = "2012-06-08"
  s.description = "This gem adds a 'pry' command to invoke Pry in the current context."
  s.email = ["obrien.andrew@gmail.com", "jrmair@gmail.com"]
  s.homepage = "http://github.com/pry/debugger-pry"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Adds a 'pry' command to debugger"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pry>, [">= 0.9.9"])
      s.add_runtime_dependency(%q<debugger>, ["~> 1"])
    else
      s.add_dependency(%q<pry>, [">= 0.9.9"])
      s.add_dependency(%q<debugger>, ["~> 1"])
    end
  else
    s.add_dependency(%q<pry>, [">= 0.9.9"])
    s.add_dependency(%q<debugger>, ["~> 1"])
  end
end
