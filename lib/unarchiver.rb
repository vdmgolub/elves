class Unarchiver
  def self.search(path)
    Dir["#{File.expand_path(path)}/*.rar"]
  end
end
