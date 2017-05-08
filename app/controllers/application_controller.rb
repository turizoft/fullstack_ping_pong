class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # Filters
  before_action :authenticate_user!
end
