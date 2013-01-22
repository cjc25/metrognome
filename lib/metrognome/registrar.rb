module Metrognome
  class Registrar
    class << self
      def registered
        @registered ||= []
      end

      def register scheduler
        raise ArgumentError.new "scheduler must be a Metrognome::Scheduler!" unless scheduler.is_a? Metrognome::Scheduler

        @registered ||= []
        @registered << scheduler
        scheduler.lock = next_filename
        scheduler.last = Time.now - 1.year
        scheduler.call_setup
      end

      private
        def next_filename
          @counter ||= 0
          @counter += 1
          "metrognome-#{@counter}"
        end
    end
  end
end

