require 'usersystem_api_helper'
require 'synchronize_session'

SynchronizeSession::SESSION_UPDATE_INTERVAL = 10 # /10秒更新代码
SynchronizeSession::USER_SESSION_KEY = 'user'
EXCEPT_ACTIONS = ['back']

ActionController::Base.class_eval do
  include SynchronizeSession
  before_filter :synchronize_session, :except => EXCEPT_ACTIONS
end
