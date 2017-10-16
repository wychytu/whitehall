class Whitehall::AssetManagerStorage < CarrierWave::Storage::Abstract
  def store!(file)
    original_file = file.to_file
    temporary_location = File.join(
      Whitehall.asset_manager_tmp_dir,
      SecureRandom.uuid,
      File.basename(original_file)
    )

    FileUtils.mkdir_p(File.dirname(temporary_location))
    FileUtils.cp(original_file, temporary_location)
    legacy_url_path = File.join('/government/uploads', uploader.store_path)
    AssetManagerWorker.perform_async(temporary_location, legacy_url_path)
    file
  end

  # def store!(file)
  #   path_to_file = uploader.store_path
  #   AssetManagerFile.new(path_to_file).store
  # end

  def retrieve!(identifier)
    path_to_file = uploader.store_path(identifier)
    AssetManagerFile.new(path_to_file)
  end

  class AssetManagerFile
    def initialize(path_to_file)
      @legacy_url_path = File.join('/government/uploads', path_to_file)
    end

    # def store
    #   client = GdsApi::AssetManager.new('http://localhost:3000', bearer_token: '12345678')
    #   client.create_whitehall_asset(file: File.open('/Users/chrisroos/Desktop/wem-logo-960x640.png'), legacy_url_path: @legacy_url_path)
    # end

    def delete
      AssetManagerRemoveWhitehallAssetWorker.perform_async(@legacy_url_path)
    end

    def url
      # We seem to need this in order to "show" images in whitehall admin
      @legacy_url_path
    end
  end
end
