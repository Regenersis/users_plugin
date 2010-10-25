module Migrations
  module TableDefinitionHelper
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def userstamps
        column(:created_by, :string)
        column(:updated_by, :string)
      end
    end
  end

  module SchemaHelper
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods

      def add_userstamps(table)
        add_column table, :created_by, :string
        add_column table, :updated_by, :string
      end

      def remove_userstamps(table)
        remove_column table, :created_by
        remove_column table, :updated_by
      end
    end
  end
end
ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Migrations::TableDefinitionHelper)
ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, Migrations::SchemaHelper)