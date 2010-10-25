module Users
  module Helper
    include Session

    def restricted_link_to(name, url)
      link_to name, url if current_user.can_access(url)
    end
  end
end