class EntryController < ApplicationController
 
    set(:authenticate) do |authenticate_required|
      condition do
        if authenticate_required && !logged_in? # if not logged in you will not be able to view posts, redirect to login to authenticate true and see posts when logged in.
          redirect "/login", 301
        end
      end
    end
      #can view all owned entries if logged in, otherwise redirect to login
    get '/entries', authenticate: true do 
      @entries = current_user.entries
      @calories = current_user.calorie_amount 
      erb :'entries/index'
    end
      
    get '/entries/new', authenticate: true do
      erb :'entries/new' #user can create new entry
    end
        
    get '/entries/calories', authenticate: true do
      if params[:after_date].present? #calorie total method by date
        @after_date = params[:after_date]
        @calories = current_user.entries.where("date >= ?", params[:after_date]).sum(:calories)
      else
        @calories = current_user.calorie_amount
      end
      erb :"/entries/calories"
    end

    post '/entries', authenticate: true do  
      if params[:entry].select{|key, value| value == ""}.empty?
        @entry = current_user.entries.create(params[:entry]) #create new entry
        redirect to "/entries/#{@entry.id}"
      else
        flash[:message] = "Please fill in the form completely" #flash message method if form is not filled in
        redirect to "/entries/new"
      end
    end
      
    get '/entries/:id', authenticate: true do #show method to show single entry 
      @entry = Entry.find(params[:id])
      if permit_user(@entry)
      erb :'entries/show'
      else 
        redirect to "/entries"
      end
      
    end
      
    get '/entries/:id/edit', authenticate: true do  # if entry is owned by current user, they can edit the previously submitted entry.
      @entry = Entry.find(params[:id])
      if permit_user(@entry)
        erb :'entries/edit'
      else 
        redirect '/entries'
      end

    end
      
    patch '/entries/:id', authenticate: true do
      if params[:entry].select{|key, value| value == ""}.empty? 
        @entry = Entry.find(params[:id])
        @entry.update(params[:entry])
        @entry.save
        redirect to "/entries/#{@entry.id}"
      else
        flash[:message] = "Please fill in the form completely" # if the value is empty use flash to show message of incomplete form submission, otherwise save edit.
        redirect to "/entries/#{params[:id]}/edit"
      end
    end

    delete '/entries/:id/delete', authenticate: true do  # allows logged in user to delete their entry
      @entry = Entry.find(params[:id])
      if permit_user(@entry)
        @entry.destroy
        redirect to '/entries'
      else 
        redirect to '/entries'
      end

    end
end