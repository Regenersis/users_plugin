module Users
  module Session
    def current_user
      User.new(JSON.parse(session[:user]))
    end
  end
end
