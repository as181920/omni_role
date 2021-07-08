class CreateOmniRoleUserRoleMaps < ActiveRecord::Migration[6.1]
  def change
    create_table :omni_role_user_role_maps do |t|
      t.belongs_to :user, polymorphic: true
      t.belongs_to :role
    end
  end
end
