module Metrognome
  class Runner
    class << self
      # TODO pull out reaper_interval into config
      attr_accessor :running, :reaper_last
      REAPER_INTERVAL = 1

      def start
        setup

        loop do
          if @_sigterm
            running.each { |t| t.kill }
            reap
            break
          end
          reap if Time.now - reaper_last > REAPER_INTERVAL

          Metrognome::Registrar.registered.each do |sched|
            if Time.now - sched.last > sched.interval
              running << Thread.new do
                sched.call_task

                # DB connections will no longer be closed automatically, so
                # close it manually here
                ActiveRecord::Base.connection.close
              end
            end
          end
          # TODO GCD sleep instead of 1
          sleep 1
        end

        Metrognome::Registrar.registered.each { |s| File.delete s.lock }
      end

      private
        def setup
          require 'set'
          self.running = Set.new
          self.reaper_last = Time.now

          Signal.trap "TERM" do
            exit 1 if @_sigterm
            @_sigterm = 1
          end
        end

        def reap
          running.delete_if { |t| t.join(0) }
          self.reaper_last = Time.now
        end
    end
  end
end
