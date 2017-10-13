class LogoUploader < WhitehallUploader
  include CarrierWave::MiniMagick

  storage :asset_manager#_and_file_system

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  version :thumb do
    process resize_to_fill: [100, 100]
  end
end
