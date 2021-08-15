module OmniRole
  class Role < ApplicationRecord
    include Permissible

    belongs_to :resource, polymorphic: true, optional: true
    has_many :user_role_maps, dependent: :destroy

    validates_presence_of :name
    validates_uniqueness_of :name, scope: [:resource_type, :resource_id]

    def users_count
      user_role_maps.count
    end
  end
end
