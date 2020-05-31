require './config/environment'

class ApplicationController < Sinatra::Base

  #enable :sessions

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret , "secret"
  end

  
  get '/' do
    "Welcome to Fwitter"
  end
  
  get '/signup' do
    if session[:user_id].nil?
        erb :'signup'
    else
        redirect '/tweets'
    end
  end

  post '/signup' do
    @user = User.new(username: params[:username], email: params[:email], password: params[:password])
    if !(@user.username.empty? || @user.email.empty? || @user.password.nil?)
        @user.save
        #binding.pry

        session[:user_id] = @user.id
        redirect "/tweets"
    else
        redirect '/signup'
    end
  end

  get '/login' do
    if !session[:user_id].nil?
        redirect to '/tweets'
    else
        erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    #binding.pry
    if !@user.nil? && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        #binding.pry
        redirect to "/tweets"
    else
        redirect to '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

  
  
end
