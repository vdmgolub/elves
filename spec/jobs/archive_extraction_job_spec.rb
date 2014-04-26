require_relative '../spec_helper'
require_relative '../../lib/jobs/archive_extraction_job'

describe ArchiveExtractionJob do
  it "extracts an archive" do
    path = "path/to/archive"
    destination_path = "path/to/extract"
    Unarchiver.expects(:extract_from_path).with(path, destination_path)

    ArchiveExtractionJob.perform(path, destination_path)
  end
end
