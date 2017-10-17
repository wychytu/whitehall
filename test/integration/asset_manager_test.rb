require 'test_helper'

class AssetManagerIntegrationTest < ActiveSupport::TestCase
  test 'creating an asset uploads logos to file system and asset manager' do
    Whitehall.stubs(:use_asset_manager).returns(true)

    filename = '960x640_jpeg.jpg'
    organisation = FactoryGirl.build(
      :organisation,
      organisation_logo_type_id: OrganisationLogoType::CustomLogo.id,
      logo: File.open(Rails.root.join('test', 'fixtures', 'images', filename))
    )

    # ensure logo has been sent to asset manager
    Services.asset_manager.expects(:create_whitehall_asset).with do |args|
      args[:file].is_a?(File) &&
        args[:legacy_url_path] =~ /#{filename}/
    end

    organisation.save!

    # ensure asset is awaiting virus scanning
    assert File.exist?(organisation.logo.path)
  end
end
