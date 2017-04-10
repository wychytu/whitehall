require 'test_helper'

class HtmlPublicationDownloaderTest < ActiveSupport::TestCase
  describe '.download_url' do
    it 'includes basic authentication when provided' do
      url = HtmlPublicationDownloader.download_url('/my-path', 'user:pass')

      assert_equal(
        'https://user:pass@www.test.alphagov.co.uk/my-path',
        url,
        'Expected URL to include basic authentication'
      )
    end

    it 'does not include any basic auth when not provided' do
      url = HtmlPublicationDownloader.download_url('/my-path', nil)

      assert_equal(
        'https://www.test.alphagov.co.uk/my-path',
        url,
        'Expected URL to not include basic authentication'
      )
    end
  end
end
