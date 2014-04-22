# Unrar-nonfree is used

class Unrar
  def self.list(path)
    `unrar lb #{path}`.split("\n")
  rescue
    []
  end
end
