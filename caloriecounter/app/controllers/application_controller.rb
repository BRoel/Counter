require './config/environment'
require 'rack-flash'


class ApplicationController < Sinatra::Base

  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "JXNkJNLmBBs"
  end

  get '/' do
    if logged_in?
      redirect to('/entries')
    else
      erb :welcome
    end
  end

  helpers do

    def current_user
      @current_user ||= User.find(session[:user_id])
    end
    
    def logged_in?
      !!session[:user_id]
    end

    def permit_user(entry)
      if entry.user == current_user
        erb :'entries/edit'
      else
        redirect to '/entries'
      end
    end

  end

end