module Metrognome
  class Registrar
    include Singleton

    def self.register scheduler
      self.instance.register scheduler
    end

    def register scheduler
      unless scheduler.is_a? Metrognome::Scheduler
        raise ArgumentError.new "scheduler #{scheduler.inspect} must be a Metrognome::Scheduler."
      end

      @registered ||= []
      @registered << scheduler
    end

    def start
      @registered.each { |scheduler| scheduler.run }

      wait_for_sigterm
      Signal.trap("TERM") { exit 1 }

      @registered.each do |scheduler|
        scheduler.stop
        scheduler.thread.run
      end
      @registered.each { |scheduler| scheduler.thread.join }
    end

    private
      # Sleep until we get a SIGTERM.
      def wait_for_sigterm
        Signal.trap("TERM") { return }
        sleep
      end
  end
end

