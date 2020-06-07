class UsersController < ApplicationController

  get '/signup' do
    if is_logged_in?
      redirect '/tweets'
    else
      erb :'users/signup'
    end
  end




end
