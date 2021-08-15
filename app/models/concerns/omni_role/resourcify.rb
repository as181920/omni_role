module OmniRole
  module Resourcify
    extend ActiveSupport::Concern

    included do
      has_many :roles, class_name: "OmniRole::Role", as: :resource, dependent: :destroy
    end

    class_methods do
      def with_role(role_name, owner=nil)
        role_list = owner.present? ? (owner.role_names(self) & Array(role_name).map(&:to_s)) : Array(role_name)
        role_tbn = Role.table_name
        joins("INNER JOIN #{role_tbn} ON #{role_tbn}.resource_type = '#{self.name}' AND #{role_tbn}.resource_id IS NULL").where("#{role_tbn}.name" => role_list)
      end

      def grant_role(role_name, owner)
        owner.add_role(role_name, self)
      end

      def invoke_role(role_name, owner)
        owner.remove_role(role_name, self)
      end
    end

    def grant_role(role_name, owner)
      owner.add_role(role_name, self)
    end

    def invoke_role(role_name, owner)
      owner.remove_role(role_name, self)
    end
  end
end
