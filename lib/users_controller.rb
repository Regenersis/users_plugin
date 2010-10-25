module Users
  module Controller

    def self.included(base)
      base.class_eval do
        include InstanceMethods
        include Session

        before_filter :init_user
        before_filter CASClient::Frameworks::Rails::Filter

        around_filter :handle_user_for_json_requests
        before_filter :set_user
        before_filter :can_access

        include SentientController

        before_filter :session_timeout

      end
    end

    module InstanceMethods

      def logout
        session.clear
        request.cookies.clear        
        logger.info ":::::::Auto redirect to #{self.request.url}::::::::::::"
        CASClient::Frameworks::Rails::Filter.logout(self, self.request.url)
      end

      def session_timeout
        time = 30.minutes
        if session[:expires_at]
          if session_has_timed_out?
            logger.info "::: Session has expired, resetting session."
            logout
            return false
          else
            initialize_session_expiry(time)
          end
        else
          initialize_session_expiry(time)
        end
      end

      def initialize_session_expiry(time)
        expires_at = time.from_now
        session[:expires_at] = expires_at
      end

      def session_has_timed_out?
        Time.now > session[:expires_at]
      end

      def handle_user_for_json_requests
        if request.url =~ /json/
          session[:user] = User.new(:username => "json_user", :roles => [{"name" => "Access all areas", "path" => "^\\S*"}]).to_json
          yield
          session[:user] = nil
        else
          yield
        end
      end

      def set_user
        session[:user] = User.find(session[:cas_extra_attributes][:id]).to_json if session[:user].nil?
      end

      def can_access
        render 'shared/access_denied' unless current_user.can_access(request.url)
      end

      def init_user
        if ["development", "test"].include?(RAILS_ENV)
          CASClient::Frameworks::Rails::Filter.fake("homer")
        end
      end
    end
  end
end
