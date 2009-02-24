require 'usersystem_api_helper'

if ENABLE_SSO
  require 'synchronize_session'

  ActionController::Base.class_eval do
    include SynchronizeSession
    before_filter :synchronize_session, :except => EXCEPT_ACTIONS
  end
end
