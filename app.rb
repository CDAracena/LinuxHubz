require 'sinatra'
require './models'
require 'shotgun'

set :session_secret, ENV['USER_PASSWORD_SECRET']
enable :sessions

get('/') do

  erb (:index)
end


get('/create') do

  erb(:add)
end

post ('/create/new') do
  Blog.create(name: params[:name], description: params[:description])

  redirect '/mydashboard'
end

get('/aboutLHubz') do

  erb(:about)
end

get('/usercreate') do

 erb (:userCreate)
end

post ('/usercreate') do
  existing_user = User.find_by(email: params[:email])
  if existing_user != nil
    return redirect '/usercreate'
  end

    user = User.create(
      user_name: params[:user_name],
      password: params[:password],
      email: params[:email],
      birthday: params[:birthday],
    )
    session[:user_id] = user.id

  redirect '/'
end

get ('/loginUser') do

  erb (:userLogin)
end

post ('/loginUser') do

  user_id = session[:user_id]
  if user_id.nil?
    return redirect '/'
  end

    unless user.password == params[:password]
      return redirect '/login'
    end

    session[:user_id] = user.id
    redirect '/mydashboard'
end

get('/mydashboard') do

  user_id = session[:user_id]
  if user_id.nil?
    return redirect '/'
    @user = User.find(user_id)

    @blogposts = Blog.all
  end
  erb (:dashboard)
end
