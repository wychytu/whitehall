require 'whitehall/carrier_wave/sanitized_file'

class Whitehall::AssetManagerStorage < CarrierWave::Storage::Abstract
  def store!(file)
    # raise file.class.inspect
    Services.asset_manager.create_asset(file: file.to_file)
    file

    # path = ::File.expand_path(uploader.store_path, Whitehall.incoming_uploads_root)
    # file.copy_to(path, uploader.permissions)
  end

  def retrieve!(identifier)
    raise 'AssetManagerStorage#retrieve!'
    # Services.asset_manager.update_asset(asset_id, file: file.file.to_file)
  end
end
