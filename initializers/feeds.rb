require 'yaml'

class Feeds
  def self.path
    File.expand_path File.join(File.dirname(__FILE__), '..', 'config', 'feeds.yml')
  end

  def self.config
    @config ||= YAML.load_file(path)
  end
end
