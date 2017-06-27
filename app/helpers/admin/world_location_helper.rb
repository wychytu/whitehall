module Admin::WorldLocationHelper

  def world_location_tabs(world_location)
    tabs = {
      "Details" => admin_world_location_path(world_location),
      "Features" => features_admin_world_location_path(world_location, locale: "")
    }
    tabs
  end
end
