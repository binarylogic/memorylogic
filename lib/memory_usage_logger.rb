module BinaryLogic
  module MemoryUsageLogger
    private
      def rendering_runtime(*args)
        msg = super
        memory_usage = `ps -o rss= -p #{$$}`.to_i
        msg + " | PID: #{$$} | Memory Usage: #{memory_usage}"
      end
  end
end

ActionController::Base.send(:include, BinaryLogic::MemoryUsageLogger)