require 'net/http'

class HtmlPublicationDownloader
  def self.download_url(base_path, auth = ENV['BASIC_AUTH_CREDENTIALS'])
    www = Plek.find('www')

    if auth.nil?
      [www, base_path].join('')
    else
      protocol, hostname = *www.split('://')

      [protocol, '://', auth, '@', hostname, base_path].join('')
    end
  end

  def self.download(base_path)
    url = download_url(base_path)

    open(url).read
  end
end
