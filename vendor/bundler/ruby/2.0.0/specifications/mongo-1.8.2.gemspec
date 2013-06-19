# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mongo"
  s.version = "1.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tyler Brock", "Gary Murakami", "Emily Stolfo", "Brandon Black"]
  s.date = "2013-01-17"
  s.description = "A Ruby driver for MongoDB. For more information about Mongo, see http://www.mongodb.org."
  s.email = "mongodb-dev@googlegroups.com"
  s.executables = ["mongo_console"]
  s.files = ["bin/mongo_console"]
  s.homepage = "http://www.mongodb.org"
  s.require_paths = ["lib"]
  s.rubyforge_project = "mongo"
  s.rubygems_version = "2.0.0"
  s.summary = "Ruby driver for MongoDB"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bson>, ["~> 1.8.2"])
    else
      s.add_dependency(%q<bson>, ["~> 1.8.2"])
    end
  else
    s.add_dependency(%q<bson>, ["~> 1.8.2"])
  end
end
