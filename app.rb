require 'sinatra'
require 'resque'
require_relative './lib/jobs/extract_job'

get '/' do
  "Server is running"
end

post '/extract' do
  path = params[:path]

  if path
    Resque.enqueue(ExtractJob, path)

    "Job added"
  else
    status 422

    "Path parameter is missing"
  end
end
