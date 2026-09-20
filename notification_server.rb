# notification_server.rb
require 'faye/websocket'
require 'eventmachine'
require_relative 'logger'
require_relative 'config'

# NotificationServer encapsulates an asynchronous WebSocket server.
class NotificationServer
  # @param host [String] bind address
  # @param port [Integer] listen port
  def initialize(host: Config[:host], port: Config[:port].to_i)
    @host    = host
    @port    = port
    @clients = []
  end

  # Starts the EventMachine loop and begins accepting connections.
  # @return [void]
  def start
    AppLogger.info "WebSocket server listening on #{@host}:#{@port}"
    EM.run do
      EM.start_server(@host, @port, Connection) do |conn|
        conn.server = self
      end
      trap_signals
    end
  rescue StandardError => e
    AppLogger.error "Server failed to start: #{e.message}"
    raise
  end

  # Broadcast a message to all connected clients.
  # @param message [String] the payload to send
  # @return [void]
  def broadcast(message)
    AppLogger.debug "Broadcasting to #{client_count} clients"
    @clients.each do |ws|
      ws.send(message)
    rescue StandardError => e
      AppLogger.warn "Failed to send to a client: #{e.message}"
    end
  end

  # Register a newly opened WebSocket connection.
  # @param ws [Faye::WebSocket::Connection]
  # @return [void]
  def register(ws)
    @clients << ws
    AppLogger.info "Client connected (#{client_count} total)"
  end

  # Unregister a closed WebSocket connection.
  # @param ws [Faye::WebSocket::Connection]
  # @return [void]
  def unregister(ws)
    @clients.delete(ws)
    AppLogger.info "Client disconnected (#{client_count} total)"
  end

  private

  def client_count = @clients.size

  # Gracefully handle termination signals.
  def trap_signals
    %w[INT TERM].each do |sig|
      Signal.trap(sig) do
        AppLogger.info "Shutting down WebSocket server..."
        EM.stop
      end
    end
  end

  # Internal connection handler for each client.
  class Connection < EM::Connection
    attr_accessor :server

    def post_init
      @ws = Faye::WebSocket.new(self)

      @ws.on(:open) { server.register(@ws) }
      @ws.on(:message) { |event| handle_message(event.data) }
      @ws.on(:close) { server.unregister(@ws) }
    end

    def receive_data(data)
      @ws.receive(data)
    end

    def unbind
      @ws.close
    end

# rewrote this part
    private

    def handle_message(data)
      AppLogger.debug "Received from client: #{data}"
      # Echo back – replace with domain‑specific logic as needed.
      @ws.send("Echo: #{data}")
    end
  end
end