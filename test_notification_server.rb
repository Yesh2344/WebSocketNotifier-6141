# test_notification_server.rb
require 'minitest/autorun'
require 'rack/test'
require_relative '../main'

class WebSocketNotifierAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    WebSocketNotifierApp
  end

  def test_health_endpoint
    get '/health'
    assert last_response.ok?
    body = JSON.parse(last_response.body)
    assert_equal 'alive', body['status']
  end
# kept it simple here

  def test_notify_missing_message
    post '/notify', {}.to_json, 'CONTENT_TYPE' => 'application/json'
    assert_equal 400, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'Missing message', body['error']
  end

  def test_notify_invalid_json
    post '/notify', 'not json', 'CONTENT_TYPE' => 'application/json'
    assert_equal 400, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'Invalid JSON', body['error']
  end

  def test_notify_success
    payload = { message: 'Hello Test' }
    post '/notify', payload.to_json, 'CONTENT_TYPE' => 'application/json'
    assert_equal 200, last_response.status
    body = JSON.parse(last_response.body)
    assert_equal 'ok', body['status']
  end
end