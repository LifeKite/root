# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Rlifekite::Application.load_tasks

RDoc::Task.new :rdoc do |rdoc|
  # @TODO: Enable this when we have an actual honest to goodness readme
  # rdoc.main = "README.rdoc"
  
  rdoc.rdoc_files.include("doc/*.rdoc", "app/**/*.rb", "lib/*.rb", "config/**/*.rb")

  rdoc.title = "LifeKite Documentation"
  rdoc.options << "--all"
  
end
