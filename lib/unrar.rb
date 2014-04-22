# Unrar-nonfree is used

class Unrar
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def filenames
    `unrar lb #{path}`.split("\n")
  rescue
    []
  end
end
