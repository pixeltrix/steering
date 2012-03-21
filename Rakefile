#!/usr/bin/env rake
require "rake/testtask"
require "bundler/gem_tasks"

desc "Default: run handlebars unit tests."
task :default => :test

Rake::TestTask.new do |t|
  t.libs += %w[lib test]
  t.pattern = "test/**/*_test.rb"
  t.warning = true
end