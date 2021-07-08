module OmniRole
  class Permission < ApplicationRecord
    validates :name, presence: true, uniqueness: true
  end
end
