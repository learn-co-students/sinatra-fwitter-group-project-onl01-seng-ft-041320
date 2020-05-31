class UsersController < ApplicationController

    #enable :sessions



    get "/users/:slug" do
        @user = User.find_by(username: params[:slug])
        erb :'users/account'
    end

end
