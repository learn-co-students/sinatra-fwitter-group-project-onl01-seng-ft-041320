class TweetsController < ApplicationController

    #enable :sessions

    get '/tweets' do
        #binding.pry
        if !session[:user_id].nil?
            @user = User.find_by(id: session[:user_id])
            @tweets = Tweet.all
            erb :'tweets/index'
        else
            redirect to "/login"
        end
    end

    get '/tweets/new' do
        if Helpers.is_logged_in?(session)
            erb :'tweets/new'
        else
            redirect to '/login'
        end
    end

    post '/tweets' do
        if !params[:content].empty?
            Tweet.create(user_id: session[:user_id], content: params[:content])
            redirect to '/tweets'
        else
            redirect to '/tweets/new'
        end
    end

    get "/tweets/:id" do
        if Helpers.is_logged_in?(session)
            @tweet = Tweet.find_by(id: params[:id].to_i)
            erb :'tweets/tweet'
        else
            redirect to '/login'
        end
    end

    get "/tweets/:id/edit" do
        if Helpers.is_logged_in?(session)
            @tweet = Tweet.find_by(id: params[:id].to_i)
            if session[:user_id] == @tweet.user_id
                erb :'tweets/edit'
            else
                redirect to '/tweets'
            end
        else
            redirect to '/login'
        end
    end

    patch '/tweets/:id' do
        if params[:content].empty?
            redirect to "/tweets/#{params[:id]}/edit"
        else
            @tweet = Tweet.find_by(id: params[:id].to_i)
            @tweet.content = params[:content]
            @tweet.save

            redirect to '/tweets'
        end
    end

    delete "/tweets/:id" do
        @tweet = Tweet.find_by(id: params[:tweet_id].to_i)
        if session[:user_id] == @tweet.user_id
            @tweet.delete
        end
        redirect to '/tweets'
    end

end
