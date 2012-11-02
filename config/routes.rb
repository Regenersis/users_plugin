if defined?(Rails) && Rails::VERSION::MAJOR == 3
  Rails.application.routes.draw do
    match "/pages/logout" => "application#logout"
  end
else
  # Redefine clear! method to do nothing (usually it erases the routes)
  class << ActionController::Routing::Routes;self;end.class_eval do
    define_method :clear!, lambda {}
  end

  ActionController::Routing::Routes.draw do |map|
    map.connect '/pages/logout', :controller => 'application', :action => 'logout'
  end
end
