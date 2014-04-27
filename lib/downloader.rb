require 'mechanize'

class Downloader
  attr_accessor :prefix, :ext, :destination

  def initialize(options = {})
    @prefix = options["prefix"] || options[:prefix]
    @ext = options["ext"] || options[:ext]

    destination = options["destination"] || options[:destination]
    @destination = File.expand_path(destination) if destination
  end

  def run(title, url)
    filename = get_filename(title, url)
    full_path = File.join(destination, filename)

    File.exists?(full_path) ? filename : File.basename(download(full_path, url))
  end

  private

  def agent
    @agent ||= Mechanize.new
  end

  def get_filename(title, url)
    filename = if title && ext
                 title = title.downcase.gsub(" ", ".")

                 "#{title}.#{ext}"
               else
                 file = agent.head(url)
                 file.filename
               end

    prefix ? "#{prefix}.#{filename}" : filename
  end

  def download(filename, url)
    file = agent.get(url)

    file.body.empty? ? "" : file.save!(filename)
  rescue
    ""
  end
end
