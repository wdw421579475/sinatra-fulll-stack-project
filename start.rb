require 'sinatra'
require './user_info'

configure do
    enable :sessions
end

get '/' do
    erb :index
end

get '/login' do
    erb :login
end

get '/signup' do
    erb :signup
end

post '/login' do
	u_name = params[:username]
    pw = params[:password]
    user_id = User_info.first(:User_name => u_name)
    if user_id != nil && user_id.Password == pw
        session[:win] = 0
        session[:lost] = 0
        session[:password] = pw
        session[:user] = u_name
        session[:total_win] = user_id.Win
        session[:total_lost] = user_id.Lost
        session[:id] = user_id.User_id
        erb :gamble
    else
        session[:notice] = "Wrong username/password!"
        redirect '/login'
    end
end

post '/signup' do
    u_name = params[:username]
    if User_info.first(:User_name => u_name) != nil
        session[:notice] = "This Username already exists"
        redirect '/signup'
    else
        User_info.create({:User_name => u_name, :Password => params[:password]})
        session[:notice] = "Account created!"
        redirect '/login'
    end
end

post '/bet' do
    money = params[:money].to_i
    guess = params[:guess].to_i
    roll = rand(6) + 1
    if guess == roll
      session[:notice] = "You win! The number is #{roll}"
      session[:win] += (money*10)
      erb :gamble
    else
      session[:notice] = "You lose! The right number is #{roll}"
      session[:lost] += money
      erb :gamble
    end
end

get '/logout' do
    session[:user] = nil
    session[:password] = nil
    user = User_info.get(session[:id])
    session[:total_win]+= session[:win]
    session[:total_lost]+= session[:lost]
    user.update(:Win=>session[:total_win],:Lost=>session[:total_lost])
    erb :login
    redirect '/'
end
