require 'sinatra'
require './models'


get('/') do

  erb (:index)
end


get('/create') do

  erb(:add)
end

get('/aboutLHubz') do

  erb(:about)
end
