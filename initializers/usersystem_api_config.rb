API_USER_ID   = '1'
API_USER_KEY  = '149825cf0a6287b07ced1509472bf202'
ENABLE_SSO = true # 是否启用sso
mode = 'local'

## url地址设置
case mode  # 3 mode local, test, production
when 'local'
  CAS_URL = "http://localhost:443"
  USERSYSTEM_URL = "http://localhost:3000"
when 'alpha'
  CAS_URL = "http://cas.alpha.ali-dev.com"
  USERSYSTEM_URL = "http://login.alpha.ali-dev.com"
when 'beta'
  CAS_URL = "http://cas.beta.ali-dev.com"
  USERSYSTEM_URL = "http://login.beta.ali-dev.com"
when 'production'
  CAS_URL = "http://cas.alixueyuan.net"
  USERSYSTEM_URL = "http://login.alixueyuan.net"
else
  CAS_URL = "http://localhost:443"
  USERSYSTEM_URL = "http://localhost:3000"
end

# cas client 配置, 如果sso不启动就关闭
if ENABLE_SSO
  require 'synchronize_session'  
  EXCEPT_ACTIONS = ['back'] # 需要跳过验证的 action
  SynchronizeSession::SESSION_UPDATE_INTERVAL = 10 # /10秒更新代码
  
  # add to global before_filter
  ActionController::Base.class_eval do
    include SynchronizeSession
    before_filter :synchronize_session, :except => EXCEPT_ACTIONS
  end

  cas_logger = CASClient::Logger.new(RAILS_ROOT+'/log/cas.log')
  cas_logger.level = Logger::DEBUG

  CASClient::Frameworks::Rails::Filter.configure(
   :cas_base_url => CAS_URL,
   :logger => cas_logger,
   :authenticate_on_every_request => true
  )
  
  # 这个东西需要根据不同的系统去修改，需要能够重用。
  def set_user_session
    User.find_by_id(session[:cas_extra_attributes]['id']) # 用户系统
    #UsersystemApiHelper.get_user(session[:cas_extra_attributes]['guid']) # 课程系统
  end
end

