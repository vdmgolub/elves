require_relative '../unarchiver'

class ExtractJob
  def self.perform(path)
    Unarchiver.extract_from_path(path)
  end
end
