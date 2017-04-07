wkhtmltopdf_bin_path =
  begin
    gem_path = Bundler
      .rubygems
      .find_name('wkhtmltopdf-binary-edge')
      .first
      .full_gem_path
    gem_path + '/bin/wkhtmltopdf'
  rescue NameError
    '/usr/bin/wkhtmltopdf'
  end

PDFKit.configure do |config|
  config.wkhtmltopdf = wkhtmltopdf_bin_path
end
