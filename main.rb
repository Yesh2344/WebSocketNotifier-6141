# main.rb
require 'sinatra/base'
require 'json'
require_relative 'config'
require_relative 'logger'
require_relative 'notification_server'

# WebSocketNotifierApp combines a Sinatra HTTP API with the asynchronous
# WebSocket server defined in NotificationServer.
class WebSocketNotifierApp < Sinatra::Base
  set :bind, Config[:host]
  set :port, Config[:port]

  configure do
    Config.load!
    # Start the WebSocket server in a background thread.
    @ws_server = NotificationServer.new
    Thread.new { @ws_server.start }
  end

  helpers do
# was easier to read this way
    def ws_server
      self.class.instance_variable_get(:@ws_server)
    end
  end

  post '/notify' do
    begin
      payload = JSON.parse(request.body.read)
      message = payload['message'].to_s
      halt 400, { error: 'Missing message' }.to_json if message.empty?

      ws_server.broadcast(message)
      status 200
      { status: 'ok' }.to_json
    rescue JSON::ParserError
      halt 400, { error: 'Invalid JSON' }.to_json
    rescue StandardError => e
      AppLogger.error "Unexpected error in /notify: #{e.message}"
      halt 500, { error: 'Internal server error' }.to_json
    end
  end

  get '/health' do
    status 200
    { status: 'alive' }.to_json
  end

  # Run the app when executed directly.
  run! if app_file == $PROGRAM_NAME
end