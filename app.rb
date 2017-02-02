# add lib to the load path
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup'

require 'ec2'
require 'sinatra'
require 'json'

if development?
  require 'pry'
end

set :bind, '0.0.0.0'
set :show_exceptions, :after_handler

before do
  # if settings.production?
  #   redirect request.url.sub('http', 'https') unless request.secure?
  # end
  content_type 'application/json'
  request.body.rewind
  request_body = request.body.read
  @request_payload = JSON.parse(request_body) unless request_body.empty?
end

get '/' do
  content_type 'text/html'
  'AWS API Adapter for Nanobox. ' \
  'source: https://github.com/nanobox-io/nanobox-adapter-aws'
end

get '/meta' do
  ::EC2::Meta.to_json
end

get '/catalog' do
  ::EC2::Catalog.fetch
end

post '/verify' do
  client.verify
  status 200
end

get '/keys' do
  client.keys.to_json
end

get '/keys/:id' do
  client.key(params['id']).to_json
end

post '/keys' do
  status 201
  key_id = client.key_create(@request_payload['id'], @request_payload['key'])
  { id: key_id.to_s }.to_json
end

delete '/keys/:id' do
  client.key_delete(params['id'])
  status 200
end

get '/servers' do
  client.servers.to_json
end

get '/servers/:id' do
  client.server(params['id']).to_json
end

post '/servers' do
  status 201
  server = client.server_order(@request_payload)
  { id: server[:id].to_s }.to_json
end

delete '/servers/:id' do
  client.server_delete(params['id'])
  status 200
end

patch '/servers/:id/reboot' do
  client.server_reboot(params['id'])
  status 200
end

patch '/servers/:id/rename' do
  client.server_rename(params['id'], @request_payload['name'])
  status 200
end

def client
  key_id     = request.env['HTTP_AUTH_ACCESS_KEY_ID']
  access_key = request.env['HTTP_AUTH_SECRET_ACCESS_KEY']
  region     = request.env['HTTP_REGION_ID']
  
  ::EC2::Client.new(key_id, access_key, region)
end

error RightScale::CloudApi::HttpError do
  message = env['sinatra.error'].message
  pieces = message.match(/^(\d+): (.+)/)
  status pieces[1]
  body "AWS error - #{pieces[2]}"
end

# RightScale::CloudApi::ApiManager::Error
