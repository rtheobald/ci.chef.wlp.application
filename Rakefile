require 'rake/clean'

task :default => :all

task :all => [:knife_test, :foodcritic, :kitchen]

task :syntax => :knife_test

desc "Runs 'knife cookbook test'"
task :knife_test do
  sh "bundle exec knife cookbook test -o .. #{cookbook_name}"
end

desc "Runs 'foodcritic'"
task :foodcritic do
  sh "bundle exec foodcritic ."
end

desc "Runs 'kitchen test'"
task :kitchen do
  sh "bundle exec kitchen test"
end

desc "Runs 'knife cookbook doc'"
task :doc do
  sh "bundle exec knife cookbook doc ../#{cookbook_name}"
end


def cookbook_name
  File.basename(File.dirname(__FILE__))
end
