class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :save_original_path

  private
    def save_original_path
      session[:return_to] = request.url
    end
end
