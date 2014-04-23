require 'sinatra'
require 'resque'
require_relative './lib/jobs/extract_job'
require 'yaml'

Resque.redis.namespace = "resque:elves"

def destination_path
  unless @destination_path
    config = YAML.load_file("./config/extract.yml")
    @destination_path = File.expand_path(config["destination_path"])
  end

  @destination_path
end

configure do
  set :show_exceptions, false
end

get '/' do
  "Server is running"
end

post '/extract' do
  path = params[:path]

  if path
    Resque.enqueue(ExtractJob, path, destination_path)

    "Job added"
  else
    status 422

    "Path parameter is missing"
  end
end
