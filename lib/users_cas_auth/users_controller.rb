module Users
  module Controller

    def self.included(base)
      base.class_eval do
        include InstanceMethods
        include Session

        before_filter :init_fake_user
        before_filter :hit_cas_filter
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

      def hit_cas_filter
        json_request? ? logger.info("::: By-passing CAS for JSON request :::") :
                        CASClient::Frameworks::Rails::Filter.filter(self)
      end

      def session_timeout
        if session_has_timed_out?
          logger.info "::: Session has expired, resetting session."
          logout
          return false
        else
          initialize_session_expiry(30.minutes)
        end
      end

      def initialize_session_expiry(time)
        session[:expires_at] = time.from_now
      end

      def session_has_timed_out?
        session[:expires_at].present? && Time.now > session[:expires_at]
      end

      def handle_user_for_json_requests
        if json_request?
          session[:user] = User.new(:username => "json_user", :roles => [{"name" => "Access all areas", "path" => "^\\S*"}]).to_json
          yield
          session[:user] = nil
        else
          yield
        end
      end

      def set_user
        if bypass_cas_for_test?
          session[:user] = User.new(:username => "chris", :name => "Chris", :roles => [{:path => '^\S*$'}], :menus => []).to_json
        elsif session[:user].nil?
          find_user_from_users_application
        end
      end

      def can_access
        render 'shared/access_denied' unless current_user.can_access(request.url)
      end

      def init_fake_user
        CASClient::Frameworks::Rails::Filter.fake("homer") if bypass_cas_for_test?
      end

    private

      def find_user_from_users_application
        session[:user] = user_record.find(session[:cas_extra_attributes][:id]).to_json
      end

      def user_record
        defined?(SystemUser) ? SystemUser : User
      end

      def bypass_cas_for_test?
        ["development", "test"].include?(Rails.env)
      end

      def json_request?
        self.request.url =~ /json/
      end
    end
  end
end
