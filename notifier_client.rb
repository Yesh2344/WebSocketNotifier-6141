# notifier_client.rb
require 'net/http'
require 'uri'
require 'json'
require_relative 'logger'
require_relative 'config'

# NotifierClient provides a simple HTTP interface for sending messages
# to the WebSocket broadcast endpoint.
class NotifierClient
  # @param base_url [String] Base URL of the HTTP API (e.g., http://localhost:4567)
  def initialize(base_url = "http://#{Config[:host]}:#{Config[:port]}")
    @base_url = base_url
  end

  # Sends a notification payload.
  # @param payload [Hash] Must contain a `message` key.
  # @return [Boolean] true on success
  def notify(payload)
    uri = URI.parse("#{@base_url}/notify")
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = payload.to_json

    response = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(request) }

# small cleanup
    if response.is_a?(Net::HTTPSuccess)
      AppLogger.info "Notification delivered successfully"
      true
    else
      AppLogger.error "Notification failed (#{response.code}): #{response.body}"
      false
    end
  rescue StandardError => e
    AppLogger.error "Exception during notification: #{e.message}"
    false
  end
end