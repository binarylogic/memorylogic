module Memorylogic
  def self.included(klass)
    klass.class_eval do
      after_filter :log_memory_usage
    end
  end

  class << self
    include ActionView::Helpers::NumberHelper
  end

  def self.memory_usage
    number_to_human_size(`ps -o rss= -p #{Process.pid}`.to_i)
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
    r = add_without_memory_info(severity, message, progname, &block)
    add_without_memory_info(severity, "  \e[1;31mMemory usage:\e[0m #{Memorylogic.memory_usage}\n\n", progname, &block)
    r
  end

  alias_method_chain :add, :memory_info
end