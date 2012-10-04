$: << File.expand_path(File.dirname(__FILE__)) + '/users_cas_auth'

puts $:

require 'migration_helper'
require 'stampable'
require 'user'
require 'user_helper'
require 'user_session'
require 'user_test_helper'
require 'users_controller'
