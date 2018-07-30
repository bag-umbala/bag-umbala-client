require 'uri'

class DataController < ApplicationController
  skip_before_action :save_original_path, only: [:index, :create_session, :destroy_session]

  def index
    if session[:current_access_token]
      @me = HTTParty.get "#{ENV['OAUTH_PROVIDER_URL']}/api/v1/users/me.json", { query: { access_token: session[:current_access_token]} }

      if @me["role_code"] == ROLE_MANAGER
        redirect_to "#{ENV['OAUTH_PROVIDER_URL']}"
      elsif @me["role_code"] == ROLE_CUSTOMER
        flash[:notice] = "Đăng nhập Cửa hàng thành công!";
      end
      # redirect_to (session[:return_to] || root_path)
    else
      redirect_to "#{ENV['OAUTH_PROVIDER_URL']}/oauth/authorize?client_id=#{ENV['OAUTH_TOKEN']}&redirect_uri=#{ENV['OAUTH_REDIRECT_URI']}&response_type=code&return_to=http%3A%2F%2Flocalhost%3A3001%2Ftest"
    end
  end

  def test
    puts "test"
    if session[:current_access_token]
      @me = HTTParty.get "#{ENV['OAUTH_PROVIDER_URL']}/api/v1/users/me.json", { query: { access_token: session[:current_access_token]} }

      if @me["role_code"] == ROLE_MANAGER
        # redirect_to "#{ENV['OAUTH_PROVIDER_URL']}"
      elsif @me["role_code"] == ROLE_CUSTOMER
        flash[:notice] = "Đăng nhập Cửa hàng thành công!";
      end
      # redirect_to (session[:return_to] || root_path)
    end
  end

  def create_session
    req_params = "client_id=#{ENV['OAUTH_TOKEN']}&client_secret=#{ENV['OAUTH_SECRET']}&code=#{params[:code]}&grant_type=authorization_code&redirect_uri=#{ENV['OAUTH_REDIRECT_URI']}"
    response = HTTParty.post("#{ENV['OAUTH_PROVIDER_URL']}/oauth/token", body: req_params)
    # pp response
    session[:current_access_token] = response['access_token']
    redirect_to (session[:return_to] || root_path)
    # redirect_to root_path
  end

  def destroy_session
    # # called for Resource Owner Password Credentials Grant
    # resource_owner_from_credentials do
    #   request.params[:user] = {:email => request.params[:username], :password => request.params[:password]}
    #   request.env["devise.allow_params_authentication"] = true
    #   user = request.env["warden"].authenticate!(:scope => :user)
    #   env['warden'].logout
    #   user
    # end
    # cookies.delete '_rails_oauth_test_client_session'
    session[:return_to] = nil
    cookies.clear
    reset_session
    redirect_to root_path
  end
end
