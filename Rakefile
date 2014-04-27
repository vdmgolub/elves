require 'bundler/setup'
Bundler.require(:default)

require './app'
require 'rake/testtask'
require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  task :setup do
    require 'resque'
    require 'resque-scheduler'

    ENV['QUEUE'] = '*'

    Resque.redis = 'localhost:6379'
    Resque.redis.namespace = "resque:elves"

    schedule_path = File.join(File.dirname(__FILE__), 'config', 'schedule.yml')
    Resque.schedule = YAML.load_file(schedule_path)
  end
end


Rake::TestTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

task :default => :test
