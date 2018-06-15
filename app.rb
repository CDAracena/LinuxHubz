require 'sinatra'
require './models'
require 'byebug'

set :session_secret, ENV['USER_PASSWORD_SECRET']
enable :sessions

# overall code looks clean and the site looks nice. .erb files should be snake_case instead of camelCase 

get('/') do

  erb (:index)
end

get ('/create') do
  if session[:user_id] != nil
    @user = User.find(session[:user_id])
  end

  erb(:add)
end

post ('/create/new') do
  # should check the user is logged in here
  Blog.create(name: params[:name], description: params[:description], user_id: session[:user_id])

  redirect '/mydashboard'
end

get('/usercreate') do

  erb (:userCreate)
end

post ('/usercreate') do
  existing_user = User.find_by(user_name: params[:user_name])
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

  redirect '/mydashboard'
end

get ('/loginUser') do

  erb (:userLogin)
end

post ('/loginUser') do

  existing_user = User.find_by(user_name: params[:user_name])
  if existing_user.nil?
     return redirect '/loginUser'
  end

  unless existing_user.password == params[:password]
    return redirect '/loginUser'
  end

  session[:user_id] = existing_user.id
  redirect '/mydashboard'
end

get ('/mydashboard') do
  user_id = session[:user_id]
  if user_id.nil?
    return redirect '/create'
  end

  @user = User.find(session[:user_id])
  # you can have the database do the sorting for you using ".order" 
  @blogposts = Blog.all.sort{ |a,b| b <=> a }
  erb (:dashboard)
end

get ('/edit/:id') do
  @blog = Blog.find(params[:id])
  erb (:edit)
end

post ('/edit/:id') do
  blog = Blog.find(params[:id])
  blog.update(name: params[:name], description: params[:description])

  redirect '/mydashboard'
end


get ('/delete/:id') do
  blog = Blog.find(params[:id])
  blog.destroy

  redirect '/mydashboard'
end

get ('/logout') do
  # we don't use @user_name in our view so there's no need for this variable
  @user_name = User.find(session[:user_id])

  session.clear

  erb(:logout)
end

get ('/deleteAcct') do
  @user = User.find(session[:user_id]).destroy

  session.clear

  redirect '/'

end
