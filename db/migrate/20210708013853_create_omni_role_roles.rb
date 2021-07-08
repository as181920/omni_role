class CreateOmniRoleRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :omni_role_roles do |t|
      t.string :name, null: false

      t.belongs_to :resource, polymorphic: true

      t.timestamps

      t.index [:resource_type, :resource_id, :name], unique: true, name: "index_omni_role_roles_on_resource_and_name"
    end
  end
end
