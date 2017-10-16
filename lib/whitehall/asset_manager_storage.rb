class Whitehall::AssetManagerStorage < CarrierWave::Storage::Abstract
  def store!(file)
    path_to_file = uploader.store_path
    AssetManagerFile.new(path_to_file).store(file, uploader)
  end

  def retrieve!(identifier)
    path_to_file = uploader.store_path(identifier)
    AssetManagerFile.new(path_to_file)
  end

  class AssetManagerFile
    def initialize(path_to_file)
      @legacy_url_path = File.join('/government/uploads', path_to_file)
    end

    def store(file, uploader)
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

    def delete
      AssetManagerRemoveWhitehallAssetWorker.perform_async(@legacy_url_path)
    end

    def url
      # We seem to need this in order to "show" images in whitehall admin
      @legacy_url_path
    end
  end
end
