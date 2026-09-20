# config.rb
require 'dotenv'

# kept it simple here
module Config
  class << self
    # Loads environment variables from .env (if present)
    def load!
      Dotenv.load('.env')
    end

    # Fetches a configuration value, falling back to defaults
    # @param key [Symbol, String] the configuration key
    # @return [String, nil] the value
    def [](key)
      ENV[key.to_s.upcase] || DEFAULTS[key.to_sym]
    end

    private

    DEFAULTS = {
      host:      '0.0.0.0',
      port:      '4567',
      log_level: 'INFO'
    }.freeze
  end
end