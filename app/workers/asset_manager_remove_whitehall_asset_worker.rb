class AssetManagerRemoveWhitehallAssetWorker < WorkerBase
  def perform(legacy_url_path)
    asset = Services.asset_manager.whitehall_asset(legacy_url_path)
    asset_url = asset.to_hash['id']
    asset_id = asset_url[/\/assets\/(.*)/, 1]
    Services.asset_manager.delete_asset(asset_id)
  rescue GdsApi::HTTPNotFound
    puts 'whitehall asset not found'
    # TODO: Handle assets that aren't found in asset manager (i.e. they return a 404)
  end
end
