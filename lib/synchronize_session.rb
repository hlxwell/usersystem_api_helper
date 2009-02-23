module SynchronizeSession
  # 同步 cas session 的方法
  # 还需要把 session[:cas_user] 同步到本地来。即 session[:cas_user] 与 session[:user] 转化
  def synchronize_session
    last_update = session[:previous_redirect_to_cas] ||= Time.now

    # 三个条件到了才去更新：1 没有ticket 2 没有 login=false 3 更新时间到 4 是get操作, post put delete会有问题。
    if request.get? and params[:ticket].blank? and params[:login].blank? and (Time.now - last_update) > SESSION_UPDATE_INTERVAL
      session[:cas_user]             = nil
      session[:cas_extra_attributes] = nil
      session[:casfilteruser]        = nil
      session[:cas_sent_to_gateway]  = nil
    end

    # 成功后会设置 session[:cas_user] session[:cas_extra_attributes]
    CASClient::Frameworks::Rails::GatewayFilter.filter(self)
    #cas 信息转化到 session[:user]
    if session[:cas_extra_attributes] != nil
      # 当cas用的数据库和 usersystem 用的数据库不一样的时候，会出现问题
      # 因为 find_by_id 返回 nil
      session[USER_SESSION_KEY] = User.find_by_id(session[:cas_extra_attributes]['id'])
    else
      session[USER_SESSION_KEY] = nil
    end
  end
end