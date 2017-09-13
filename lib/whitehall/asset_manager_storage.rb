require 'whitehall/carrier_wave/sanitized_file'

class Whitehall::AssetManagerStorage < CarrierWave::Storage::Abstract
  def store!(file)
    path = "/government/uploads/system/uploads/image_data/file/#{uploader.model.id}/#{File.basename(file.file)}"
    Services.asset_manager.create_whitehall_asset(file: file.to_file, path: path)
    file
  end

  def retrieve!(identifier)
    raise 'AssetManagerStorage#retrieve!'
  end
end
