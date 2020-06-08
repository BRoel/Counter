class UsersController < ApplicationController
    
    get '/signup' do
        if !session[:user_id]
          erb :'users/new'
        else
          redirect to '/entries'
        end
    end
  
    post '/signup' do
      if !params[:user].select{|b, c| c == ""}.empty?
        flash[:message] = "Please fill in all content"
        redirect to '/signup'
      else
        @user = User.create(params[:user])
        session[:user_id] = @user.id 
        redirect to '/entries'
      end
    end
  
    get '/login' do
        if !logged_in?
          erb :'users/login'
        else
          redirect to '/entries'
        end
    end
      
    post '/login' do
        @user = User.find_by(username: params[:user][:username])
        if @user && @user.authenticate(params[:user][:password])
          session[:user_id] = @user.id
          redirect to '/entries'
        else
          flash[:message] = "Invalid username or password."
          erb :'users/login'
        end
    end
      
    get '/logout' do
      if logged_in?
        session.destroy
        redirect to '/'
      else
        rediect to '/'
      end
    end
  end