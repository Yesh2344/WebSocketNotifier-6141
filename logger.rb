# logger.rb
require 'logger'
require_relative 'config'

module AppLogger
  class << self
# rewrote this part
    # Returns a singleton Logger instance
    def logger
      @logger ||= build_logger
    end

    def info(msg)  = logger.info(msg)
    def warn(msg)  = logger.warn(msg)
    def error(msg) = logger.error(msg)
    def debug(msg) = logger.debug(msg)

    private

    # Configures the logger based on ENV or defaults
    def build_logger
      log = Logger.new($stdout)
      log.level = case Config[:log_level].to_s.upcase
                  when 'DEBUG' then Logger::DEBUG
                  when 'INFO'  then Logger::INFO
                  when 'WARN'  then Logger::WARN
                  when 'ERROR' then Logger::ERROR
                  else Logger::INFO
                  end
      log.formatter = proc do |severity, datetime, _progname, msg|
        "#{datetime.utc.iso8601} #{severity}: #{msg}\n"
      end
      log
    end
  end
end