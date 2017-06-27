# encoding: UTF-8
require "test_helper"

class Admin::WorldLocationTranslationsControllerTest < ActionController::TestCase
  setup do
    login_as :writer
    @location = create(:world_location, name: 'Afrolasia', mission_statement: 'Teaching the people how to brew tea')

    Locale.stubs(:non_english).returns([
      Locale.new(:fr), Locale.new(:es)
    ])
  end

  should_be_an_admin_controller

  test 'create redirects to edit for the chosen language' do
    post :create, world_location_id: @location, translation_locale: 'fr'
    assert_redirected_to edit_admin_world_location_translation_path(@location, id: 'fr')
  end

  view_test 'update updates translation and redirects back to the index' do
    put :update, world_location_id: @location, id: 'fr', world_location: {
      name: 'Afrolasie',
      mission_statement: 'Enseigner aux gens comment infuser le thé'
    }

    @location.reload

    with_locale :fr do
      assert_equal 'Afrolasie', @location.name
      assert_equal 'Enseigner aux gens comment infuser le thé', @location.mission_statement
    end

    assert_redirected_to admin_world_location_translations_path(@location)
  end

  view_test 'update re-renders form if translation is invalid' do
    put :update, world_location_id: @location, id: 'fr', world_location: {
      name: '',
      mission_statement: 'Enseigner aux gens comment infuser le thé'
    }

    translation_path = admin_world_location_translation_path(@location, 'fr')

    assert_select "form[action=?]", translation_path do
      assert_select "textarea[name='world_location[mission_statement]']", text: 'Enseigner aux gens comment infuser le thé'
    end
  end

  test 'destroy removes translation and redirects to list of translations' do
    location = create(:world_location, translated_into: [:fr])

    delete :destroy, world_location_id: location, id: 'fr'

    location.reload
    refute location.translated_locales.include?(:fr)
    assert_redirected_to admin_world_location_translations_path(location)
  end
end
