require_relative './spec_helper'
require_relative '../app'
require 'rack/test'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "POST /extract" do
  context "when path is provided" do
    before do
      path = "/path/to/archive"
      destination_path = "/path/to/extract"

      app.any_instance.expects(:destination_path).once.returns(destination_path)
      Resque.expects(:enqueue).with(ArchiveExtractionJob, path, destination_path).once
      post '/extract', path: path
    end

    it "returns 200" do
      last_response.ok?.must_equal true
    end

    it "returns message" do
      last_response.body.must_equal "Job added"
    end
  end

  context "when path is missing" do
    before do
      post '/extract'
    end

    it "returns 422" do
      last_response.status.must_equal 422
    end

    it "returns message" do
      last_response.body.must_equal "Path parameter is missing"
    end

  end
end
