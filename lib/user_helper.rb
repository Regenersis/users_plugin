module Users
  module Helper
    include Session

    def restricted_link_to(name, url)
      link_to name, url if current_user.can_access(url)
    end

    def restricted_confirmation_link_to(name, url, message, method)
      url = url if current_user.can_access(url)
      link_to name, url, :confirm => message, :method => method
    end
  end
end