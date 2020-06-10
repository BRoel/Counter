class UsersController < ApplicationController
    
    get '/signup' do
        if !session[:user_id] #if not logged in send to signup page
          erb :'users/new'
        else
          redirect to '/entries'
        end
    end
  
    post '/signup' do
      if !params[:user].select{|key, value| value == ""}.empty?
        flash[:message] = "Please fill in all content" #uses flash if signup form not fullly filled in
        redirect to '/signup'
      else
        @user = User.create(params[:user])
        session[:user_id] = @user.id
        redirect to '/entries'
      end
    end
  
    get '/login' do
        if !logged_in? # if logged in send user to entries index
          erb :'users/login'
        else
          redirect to '/entries'
        end
    end
      
    post '/login' do
        @user = User.find_by(username: params[:user][:username])
        if @user && @user.authenticate(params[:user][:password]) #validates user and logs them in
          session[:user_id] = @user.id
          redirect to '/entries'
        else
          flash[:message] = "Invalid username or password."
          erb :'users/login'
        end
    end
      
    get '/logout' do #logs out user, navigates to welcome page
      if logged_in?
        session.destroy
        redirect to '/'
      else
        redirect to '/'
      end
    end
  end