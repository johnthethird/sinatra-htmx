require 'rubygems'
require 'bundler'

Bundler.require

# Use Puma as server and open up CORS settings
configure do
  set :server, :puma
  enable :cross_origin
  set :allow_origin, :any
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "*"
  200
end

require './app'

run Sinatra::Application
