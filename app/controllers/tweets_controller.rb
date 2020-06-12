class TweetsController < ApplicationController


class TweetsController < ApplicationController
  enable :sessions
  set :session_secret, 'fwitter'
  set :public_folder, 'public'
  set :views, 'app/views'


  get '/tweets' do
    redirect '/login' if !logged_in?
    @tweets = Tweet.all
    erb :'/tweets/tweets'
  end


  get '/tweets/new' do
    redirect '/login' if !logged_in?
    erb :'/tweets/new'
  end

  post '/tweets' do
    redirect '/login' if !logged_in?

    @tweet = current_user.tweets.create(params[:tweet])
    if @tweet.save
      redirect "/tweets/#{@tweet.id}"
    else
      redirect '/tweets/new'
    end
  end


  get '/tweets/:id' do
    redirect '/login' if !logged_in?
    @tweet = Tweet.find(params[:id])
    erb :'/tweets/show'
  end

  
  delete '/tweets/:id/delete' do
    tweet = current_user.tweets.find_by(id: params[:id])
    if tweet && tweet.destroy
      redirect '/tweets'
    else
      redirect "/tweets/#{ params[:id] }"
    end
  end


  get '/tweets/:id/edit' do
    redirect '/login' if !logged_in?
    @tweet = Tweet.find(params[:id])
    redirect '/tweets' if @tweet.user != current_user 
    erb :'/tweets/edit'
  end

  post '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    redirect "/" if @tweet.user != current_user
    redirect "/tweets/#{@tweet.id}/edit" if params[:tweet][:content].empty?
    @tweet.content = params[:tweet][:content]
    @tweet.save
    redirect "/tweets/#{@tweet.id}"
  end
end

end
