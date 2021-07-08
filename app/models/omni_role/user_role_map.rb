module OmniRole
  class UserRoleMap < ApplicationRecord
    belongs_to :user, polymorphic: true
    belongs_to :role
  end
end
