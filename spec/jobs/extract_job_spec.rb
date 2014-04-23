require_relative '../spec_helper'
require_relative '../../lib/jobs/extract_job'

describe ExtractJob do
  it "extracts an archive" do
    path = "path/to/archive"
    Unarchiver.expects(:extract_from_path).with(path)

    ExtractJob.perform(path)
  end
end
