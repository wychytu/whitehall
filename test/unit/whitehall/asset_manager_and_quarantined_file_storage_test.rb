require 'test_helper'
require 'whitehall/asset_manager_storage'

class Whitehall::AssetManagerAndQuarantinedFileStorageTest < ActiveSupport::TestCase
  setup do
    uploader = CarrierWave::Uploader::Base.new
    @storage = Whitehall::AssetManagerAndQuarantinedFileStorage.new(uploader)
    @file = CarrierWave::SanitizedFile.new(Tempfile.new('asset'))

    @asset_manager_storage = stub('asset-manager-storage')
    Whitehall::AssetManagerStorage.stubs(:new).returns(@asset_manager_storage)
    @quarantined_file_storage = stub('quarantined-file-storage')
    Whitehall::QuarantinedFileStorage.stubs(:new).returns(@quarantined_file_storage)

    Whitehall.stubs(:use_asset_manager).returns(true)
  end

  test 'stores the file using the asset manager storage engine' do
    @asset_manager_storage.expects(:store!).with(@file)
    @quarantined_file_storage.stubs(:store!)

    @storage.store!(@file)
  end

  test 'does not store the file using the asset manager storage engine when feature flag is off' do
    Whitehall.stubs(:use_asset_manager).returns(false)

    @asset_manager_storage.expects(:store!).never
    @quarantined_file_storage.stubs(:store!)

    @storage.store!(@file)
  end

  test 'stores the file using the quarantined file storage engine' do
    @asset_manager_storage.stubs(:store!)
    @quarantined_file_storage.expects(:store!).with(@file)

    @storage.store!(@file)
  end

  test 'returns the value returned from the quarantined file store' do
    @asset_manager_storage.stubs(:store!)
    @quarantined_file_storage.stubs(:store!).with(@file).returns('stored-file')

    assert_equal 'stored-file', @storage.store!(@file)
  end

  test 'returns the composite asset manager and quarantined file' do
    @quarantined_file_storage.stubs(:retrieve!).with('identifier').returns('retrieved-quarantined-file')
    @asset_manager_storage.stubs(:retrieve!).with('identifier').returns('retrieved-asset-manager-file')

    composite_file = stub(:composite_file)
    Whitehall::AssetManagerAndQuarantinedFileStorage::File.stubs(:new).with('retrieved-asset-manager-file', 'retrieved-quarantined-file').returns(composite_file)

    assert_equal composite_file, @storage.retrieve!('identifier')
  end
end

class Whitehall::AssetManagerAndQuarantinedFileStorage::FileTest < ActiveSupport::TestCase
  setup do
    @asset_manager_file = stub(:asset_manager_file)
    @quarantined_file = stub(:quarantined_file)
    @file = Whitehall::AssetManagerAndQuarantinedFileStorage::File.new(@asset_manager_file, @quarantined_file)
  end

  test '#url returns the url from the quarantined file' do
    @quarantined_file.stubs(:url).returns('quarantined-file-url')

    assert_equal 'quarantined-file-url', @file.url
  end

  test '#path returns the path from the quarantined file' do
    @quarantined_file.stubs(:path).returns('quarantined-file-path')

    assert_equal 'quarantined-file-path', @file.path
  end

  test '#filename returns the filename from the quarantined file' do
    @quarantined_file.stubs(:filename).returns('quarantined-file-filename')

    assert_equal 'quarantined-file-filename', @file.filename
  end

  test '#content_type returns the content_type from the quarantined file' do
    @quarantined_file.stubs(:content_type).returns('quarantined-file-content-type')

    assert_equal 'quarantined-file-content-type', @file.content_type
  end

  test '#delete calls delete on both asset manager file and quarantined file' do
    @asset_manager_file.expects(:delete)
    @quarantined_file.expects(:delete)

    @file.delete
  end
end
