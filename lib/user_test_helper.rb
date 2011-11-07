module Users
  module TestHelper
    def set_updated_by
      self.updated_by = "test" if self.respond_to? :updated_by
    end

    def set_created_by
      self.created_by = "test" if self.respond_to? :created_by
    end
  end
end
