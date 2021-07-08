module OmniRole
  module Rolify
    extend ActiveSupport::Concern

    included do
      has_many :user_role_maps, class_name: "OmniRole::UserRoleMap", as: :user, dependent: :destroy
      has_many :roles, class_name: "OmniRole::Role", through: :user_role_maps do
        def on(resource=nil)
          resource.is_a?(Class) ? where(resource_type: resource.to_s, resource_id: nil) : where(resource_type: resource&.class&.name, resource_id: resource&.id)
        end
      end
      has_many :permissions, class_name: "OmniRole::Permission", through: :roles
    end

    class_methods do
      def with_role(role_name, resource=nil)
        joins_roles_for_resource(resource).where("#{Role.table_name}.name" => Array(role_name))
      end

      def without_role(role_name, resource=nil)
        joins_roles_for_resource(resource).where.not( "#{Role.table_name}.name" => Array(role_name))
      end

      def with_permission(permission_name, resource=nil)
        joins(roles: :permissions).merge(role_scope_for_resource(resource)).merge(Permission.where(name: permission_name))
      end

      def role_scope_for_resource(resource)
        # for: class name; AR object; nil
        resource.is_a?(Class) ? Role.where(resource_type: resource.to_s, resource_id: nil) : Role.where(resource_type: resource&.class&.name, resource_id: resource&.id)
      end

      private
        def joins_roles_for_resource(resource)
          if resource.is_a?(Class)
            joins(:roles).where("#{Role.table_name}.resource_type": resource.to_s, "#{Role.table_name}.resource_id": nil)
          else
            joins(:roles).where("#{Role.table_name}.resource_type": resource&.class&.name, "#{Role.table_name}.resource_id": resource&.id)
          end
        end
    end

    def add_role(role_name, resource=nil)
      self.roles |= Array(role_name).map { |rn| role_scope_for_resource(resource).find_or_create_by(name: rn) }
    end

    def remove_role(role_name, resource=nil)
      self.roles -= Array(role_name).map { |rn| role_scope_for_resource(resource).find_by(name: rn) }
    end

    def set_role(role_name, resource=nil)
      old_role_names = role_names(resource)
      (Array(role_name) - old_role_names).then { |names| add_role(names, resource) }
      (old_role_names - Array(role_name)).then { |names| remove_role(names, resource) }
    end

    def has_role?(role_name, resource=nil)
      roles.on(resource).where(name: Array(role_name)).present?
    end

    def global_roles
      roles.where(resource: nil)
    end

    def role_names(resource=nil)
      roles.on(resource).map(&:name)
    end

    def has_permission?(permission_name, resource=nil)
      # permissions.where(name: Array(permission_name)).present?
      (Array(permission_name) & permission_names(resource)).present?
    end

    def permission_names(resource=nil)
      self.permissions.merge(role_scope_for_resource(resource)).map(&:name)
    end

    private
      def role_scope_for_resource(resource)
        self.class.role_scope_for_resource(resource)
      end
  end
end
