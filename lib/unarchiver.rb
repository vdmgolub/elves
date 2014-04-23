require_relative './unrar'

class Unarchiver
  def self.search(path)
    Dir["#{File.expand_path(path)}/*.rar"]
  end

  def self.extract(file_path, destination_path)
    archive = Unrar.new(file_path)

    archive.extract(destination_path)
  end

  def self.extract_from_path(path, destination_path)
    archives = search(path)

    archives.map { |a| extract(a, destination_path) }.flatten
  end
end
