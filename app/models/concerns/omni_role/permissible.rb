module OmniRole
  module Permissible
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :permissions
      end

      class_methods do
      end

      def add_permission(permission_name)
        self.permissions |= Array(permission_name).map { |pn| Permission.find_or_create_by(name: pn) }
      end

      def remove_permission(permission_name)
        self.permissions -= Array(permission_name).map { |pn| Permission.find_by(name: pn) }
      end

      def set_permission(permission_name)
        (Array(permission_name) - permission_names).then{ |names| add_permission(names) }
        (permission_names - Array(permission_name)).then{ |names| remove_permission(names) }
      end

      def has_permission?(permission_name)
        # self.permissions.where(name: Array(permission_name)).present?
        (Array(permission_name) & permission_names).present?
      end

      def permission_names
        self.permissions.map(&:name)
      end
  end
end
