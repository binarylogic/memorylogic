module Memorylogic
  def self.included(klass)
    klass.class_eval do
      after_filter :log_memory_usage
    end
  end

  def self.memory_usage
    `ps -o rss= -p #{Process.pid}`.to_i
  end

  private
    def log_memory_usage
      if logger
        logger.info("Memory usage: #{Memorylogic.memory_usage} | PID: #{Process.pid}")
      end
    end
end

ActiveSupport::BufferedLogger.class_eval do
  def add_with_memory_info(severity, message = nil, progname = nil, &block)
    message ||= ""
    message += "\nMemory usage: #{Memorylogic.memory_usage}\n\n"
    add_without_memory_info(severity, message, progname, &block)
  end

  alias_method_chain :add, :memory_info
end