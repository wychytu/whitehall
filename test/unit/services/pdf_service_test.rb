require 'test_helper'

class PdfServiceTest < ActiveSupport::TestCase
  describe '#render_html_as_pdf' do
    before do
      @html = SecureRandom.uuid
      @file = PdfService.render_html_as_pdf(@html)
    end

    after do
      @file.delete
    end

    it 'creates a temporary PDF with content' do
      assert_match(%r(^/tmp/.+\.pdf$), @file.path)
      assert @file.size > 0
    end
  end
end
