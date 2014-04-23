require_relative '../spec_helper'
require_relative '../../lib/jobs/extract_job'

describe ExtractJob do
  it "extracts an archive" do
    path = "path/to/archive"
    destination_path = "path/to/extract"
    Unarchiver.expects(:extract_from_path).with(path, destination_path)

    ExtractJob.perform(path, destination_path)
  end
end
