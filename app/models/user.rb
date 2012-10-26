class User < ActiveResource::Base
  include SentientUser

  self.site = AppConfig.users_base_url
  self.format = :json

  def can_access(url)
    self.roles.each do |role|
      return true if url =~ Regexp.new(role.path)
    end
    false
  end
end
