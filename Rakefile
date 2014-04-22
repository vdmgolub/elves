require 'bundler/setup'
Bundler.require(:default)

require './app'
require 'resque/tasks'

namespace :resque do
  task :setup do
    require 'resque'

    ENV['QUEUE'] = '*'

    Resque.redis = 'localhost:6379'
    Resque.redis.namespace = "elves"
  end
end

