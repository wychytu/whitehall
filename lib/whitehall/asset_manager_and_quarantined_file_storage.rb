class Whitehall::AssetManagerAndQuarantinedFileStorage < CarrierWave::Storage::Abstract
  def store!(file)
    Whitehall::AssetManagerStorage.new(uploader).store!(file) if Whitehall.use_asset_manager
    Whitehall::QuarantinedFileStorage.new(uploader).store!(file)
  end

  def retrieve!(identifier)
    asset_manager_file = Whitehall::AssetManagerStorage.new(uploader).retrieve!(identifier)
    quarantined_file = Whitehall::QuarantinedFileStorage.new(uploader).retrieve!(identifier)

    File.new(asset_manager_file, quarantined_file)
  end

  class File
    delegate :url, :path, :content_type, :filename, to: :@quarantined_file

    def initialize(asset_manager_file, quarantined_file)
      @asset_manager_file = asset_manager_file
      @quarantined_file = quarantined_file
    end

    def delete
      @quarantined_file.delete
      @asset_manager_file.delete
    end
  end
end
