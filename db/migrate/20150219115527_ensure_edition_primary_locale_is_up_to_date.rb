class EnsureEditionPrimaryLocaleIsUpToDate < ActiveRecord::Migration[4.2]
  def up
    execute "UPDATE editions SET primary_locale = locale WHERE primary_locale != locale"
  end
end
