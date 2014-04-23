require 'bundler/setup'
Bundler.require(:default)

require './app'
require 'rake/testtask'
require 'resque/tasks'

namespace :resque do
  task :setup do
    require 'resque'

    ENV['QUEUE'] = '*'

    Resque.redis = 'localhost:6379'
    Resque.redis.namespace = "resque:elves"
  end
end


Rake::TestTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

task :default => :test
