class EntryController < ApplicationController
 
    set(:auth) do |auth_required|
      condition do
        if auth_required && !logged_in? 
          redirect "/login", 302
        end
      end
    end
      
    get '/entries', auth: true do 
      @entries = current_user.entries
      @calories = current_user.calorie_amount
      erb :'entries/index'
    end
      
    get '/entries/new', auth: true do
      erb :'entries/new'
    end
        
    get '/entries/calories' do
      if params[:after_date].present?
        @after_date = params[:after_date]
        @calories = current_user.entries.where("date >= ?", params[:after_date]).sum(:calories)
      else
        @calories = current_user.calorie_amount
      end
      erb :"/entries/calories"
    end

    post '/entries' do
      if !params[:entry].select{|b, c| c == ""}.empty?
        flash[:message] = "Please fill in the form completely"
        redirect to "/entries/new"
      else
        @user = current_user
        @entry = Entry.create(params[:entry])
        redirect to "/entries/#{@entry.id}"
      end
    end
      
    get '/entries/:id', auth: true do
      @entry = Entry.find(params[:id])
      erb :'entries/show'
    end
      
    get '/entries/:id/edit', auth: true do
      @entry = Entry.find(params[:id])
      permit_user(@entry)
    end
      
    patch '/entries/:id' do
      if params[:entry].select{|b, c| c == ""}.empty?
        @entry = Entry.find(params[:id])
        @entry.update(params[:entry])
        @entry.save
        redirect to "/entries/#{@entry.id}"
      else
        flash[:message] = "Please fill in the form completely"
        redirect to "/entries/#{params[:id]}/edit"
      end
    end

    delete '/entries/:id/delete', auth: true do
      @entry = Entry.find(params[:id])
      @entry.user == current_user
      @entry.destroy
      redirect to '/entries'
    end
  end