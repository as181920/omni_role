class CreateOmniRolePermissionsRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :omni_role_permissions_roles do |t|
      t.belongs_to :permission
      t.belongs_to :role
    end
  end
end
