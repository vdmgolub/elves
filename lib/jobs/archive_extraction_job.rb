require_relative '../unarchiver'

class ArchiveExtractionJob
  @queue = :default

  def self.perform(path, destination_path)
    Unarchiver.extract_from_path(path, destination_path)
  end
end
