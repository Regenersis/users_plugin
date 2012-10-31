Rails.application.routes.draw do |map|
  match "/pages/logout" => "users#logout"
end
