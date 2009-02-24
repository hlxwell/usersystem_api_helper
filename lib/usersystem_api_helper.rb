class UsersystemApiHelper
  require 'net/http'
  require 'uri'
  require 'md5'
  require 'json'
  
  def self.get_user(guid)
    return nil unless guid
    
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    com_key = MD5.new(API_USER_KEY + timestamp)
    auth_string = [
      "key=#{com_key}",
      "timestamp=#{timestamp}",
      "api_user_id=#{API_USER_ID}"
    ].join('&')

    url = URI.parse(USERSYSTEM_URL)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get("/users/#{guid}?#{auth_string}")
    }
    
    result = JSON.parse(res.body)
    
    # 必须 raise 错误方便以后查找
    raise result['info'] if result['status']
    
    return result
  end
end