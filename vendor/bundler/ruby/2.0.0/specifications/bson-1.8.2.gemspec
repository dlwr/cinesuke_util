# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "bson"
  s.version = "1.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tyler Brock", "Gary Murakami", "Emily Stolfo", "Brandon Black"]
  s.date = "2013-01-17"
  s.description = "A Ruby BSON implementation for MongoDB. For more information about Mongo, see http://www.mongodb.org. For more information on BSON, see http://www.bsonspec.org."
  s.email = "mongodb-dev@googlegroups.com"
  s.executables = ["b2json", "j2bson"]
  s.files = ["bin/b2json", "bin/j2bson"]
  s.homepage = "http://www.mongodb.org"
  s.require_paths = ["lib"]
  s.rubyforge_project = "bson"
  s.rubygems_version = "2.0.0"
  s.summary = "Ruby implementation of BSON"
end
