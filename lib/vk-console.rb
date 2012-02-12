require 'rubygems'
require 'vk-ruby'
require 'mechanize'

module VK
  class Console < Standalone
    VERSION = '0.2.1'

    def initialize(p={})
      @logger = p[:logger]    
      @debug  = p[:debug]  ||= false
      @settings  = p[:settings]  ||= 'notify,friends,photos,audio,video,docs,notes,pages,offers,questions,wall,messages,ads,offline'
      
      raise 'undefined application id' unless @app_id   = p[:app_id]
      raise 'undefined email'          unless @email    = p[:email] 
      raise 'indefined password'       unless @password = p[:password]

      super :app_id => @app_id, :settings => @settings
      raise "unauthorize" unless authorize 
    end

    private

    def authorize
      agent = Mechanize.new

      # user login
      login_page = agent.get 'http://vk.com'
      login_page.forms.first.email = @email
      login_page.forms.first.pass = @password

      agent.submit login_page.forms.first

      if agent.cookies.detect{|cookie| cookie.name == 'remixsid'}

        # application authorize
        params = {:client_id => @app_id, 
                  :scope => @settings, 
                  :display => :page, 
                  :redirect_uri => 'http://api.vk.com/blank.html', 
                  :response_type => :token}

        page = agent.get 'http://api.vk.com/oauth/authorize?' + (params.map{|k,v| "#{k}=#{v}" }).join('&')

        uri = agent.get(page.body[/\A.*function\s*approve\(\)\s?\{\s*location\.href\s*=\s*\"(.+?)\"\;\s*\}.*\z/m, 1]).uri

        reg = /\Ahttp:\/\/api\.(vkontakte\.ru|vk\.com)\/.+\#access_token=(.*?)&expires_in=(.*?)&user_id=(.*?)\z/

        @access_token, @expires_in, @user_id = *uri.to_s.match(reg)[2..4]
      end

      @access_token && @expires_in && @user_id
    end
  end
end
