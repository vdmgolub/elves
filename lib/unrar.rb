# Unrar-nonfree is used

class Unrar
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def valid?
    !!system("unrar t #{path}")
  end

  def filenames
    `unrar lb #{path}`.split("\n")
  rescue
    []
  end

  def extract(destination_path)
    if valid?
      `unrar e #{path} #{destination_path}`
      filenames.map { |f| "#{destination_path}#{f}" }
    else
      []
    end
  end
end
