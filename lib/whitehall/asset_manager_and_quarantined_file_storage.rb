class Whitehall::AssetManagerAndQuarantinedFileStorage < CarrierWave::Storage::Abstract
  def store!(file)
    Whitehall::AssetManagerStorage.new(uploader).store!(file) if Whitehall.use_asset_manager
    Whitehall::QuarantinedFileStorage.new(uploader).store!(file)
  end

  def retrieve!(identifier)
    asset_manager_file = Whitehall::AssetManagerStorage.new(uploader).retrieve!(identifier)
    sanitized_file = Whitehall::QuarantinedFileStorage.new(uploader).retrieve!(identifier)

    File.new(asset_manager_file, sanitized_file)
  end

  class File
    def initialize(asset_manager_file, sanitized_file)
      @asset_manager_file = asset_manager_file
      @sanitized_file = sanitized_file
    end

    def delete
      @asset_manager_file.delete
      @sanitized_file.delete
    end

    def url
      @sanitized_file.url
    end

    def content_type
      @sanitized_file.content_type
    end
  end
end
