require 'sinatra'
require './models'


get('/') do
  @blogposts = Blog.all
  erb (:index)
end


get('/create') do

  erb(:add)
end

post ('/create/new') do
  Blog.create(name: params[:name], description: params[:description])

  redirect '/'
end

get('/aboutLHubz') do

  erb(:about)
end
