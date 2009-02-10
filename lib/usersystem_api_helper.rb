class UsersystemApiHelper
  require 'net/http'
  require 'uri'
  require 'md5'
  require 'json'
  
  def self.get_user(guid)
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    com_key = MD5.new(API_USER_KEY + timestamp)
    auth_string = [
      "key=#{com_key}",
      "timestamp=#{timestamp}",
      "api_user_id=#{API_USER_ID}"
    ].join('&')

    url = URI.parse(USER_SYSTEM_URL)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get("/users/#{guid}?#{auth_string}")
    }
    
    JSON.parse(res.body)
  end
end