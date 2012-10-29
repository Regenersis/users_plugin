$: << File.expand_path(File.dirname(__FILE__)) + '/users_cas_auth'

if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'engine'
  require 'user_session'
  require 'user_helper'
  require 'user_test_helper'
  require 'users_controller'
  if defined?(ActiveRecord)
    require 'migration_helper'
    require 'stampable'
  end
else
  require 'user'
  require 'user_session'
  require 'user_helper'
  require 'user_test_helper'
  require 'users_controller'
  if defined?(ActiveRecord)
    require 'migration_helper'
    require 'stampable'
  end
end
