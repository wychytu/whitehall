class WorldwideOrganisationsController < PublicFacingController
  include CacheControlHelper
  enable_request_formats show: :json
  before_action :load_worldwide_organisation

  respond_to :html, :json

  def show
    respond_to do |format|
      format.html do
        set_expiry 5.minutes
        @world_locations = @worldwide_organisation.world_locations
        @main_office = @worldwide_organisation.main_office if @worldwide_organisation.main_office
        @home_page_offices = @worldwide_organisation.home_page_offices
        @primary_role = primary_role
        @other_roles = ([secondary_role] + office_roles).compact
        set_meta_description(@worldwide_organisation.summary)
        set_slimmer_organisations_header([@worldwide_organisation] + @worldwide_organisation.sponsoring_organisations)
        set_slimmer_world_locations_header(@world_locations)
      end
      format.json { redirect_to api_worldwide_organisation_path(@worldwide_organisation, format: :json) }
    end
  end

private

  def load_worldwide_organisation
    @worldwide_organisation = WorldwideOrganisation.with_translations(I18n.locale).find(params[:id])
  end

  def primary_role
    RolePresenter.new(@worldwide_organisation.primary_role, view_context) if @worldwide_organisation.primary_role
  end

  def secondary_role
    RolePresenter.new(@worldwide_organisation.secondary_role, view_context) if @worldwide_organisation.secondary_role
  end

  def office_roles
    @worldwide_organisation.office_staff_roles.map { |office_staff| RolePresenter.new(office_staff, view_context) }
  end
end
