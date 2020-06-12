require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    enable :sessions
    set :session_secret, 'fwitter'
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    if logged_in? 
      redirect to "/users/#{current_user.id}"  
    else 
    erb :index 
    end 
  end
  
  get '/signup' do
    if Helpers.logged_in?(session)
      redirect to '/tweets'
    end

    erb :"/users/create_user"
  end
  
  post '/signup' do
    
    user = User.create(:username => params["username"], :email => params["email"], :password => params["password"])
    session[:user_id] = user.id

    redirect to '/tweets'
  end

  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect to '/tweets'
    end

    erb :"/users/login"
  end

  helpers do

    def logged_in?
      !!session[:id]
    end

    def current_user
      @current_user ||= User.find(session[:id]) if session[:id]
    end

    def login(username, password)
      user = User.find_by(:username => username)
      if user && user.authenticate(password)
        session[:id] = user.id
      else
        redirect '/login'
      end
    end

    def logout!
      session.clear
    end
  end

end
