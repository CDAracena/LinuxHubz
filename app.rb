require 'sinatra'
require './models'
require 'byebug'

set :session_secret, ENV['USER_PASSWORD_SECRET']
enable :sessions

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
  @blogposts = Blog.all
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

@user_name = User.find(session[:user_id])

 session.clear

erb(:logout)
end
