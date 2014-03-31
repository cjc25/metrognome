module Metrognome
  class Scheduler
    attr_reader :description, :thread

    def initialize interval, description = 'Anonymous scheduler'
      @interval = interval
      @description = description
      @stopped = false
    end

    def setup &block
      @setup = block
    end

    def task &block
      @task = block
    end

    def stop
      @stopped = true
    end

    def run
      @thread = Thread.new do
        instance_eval(&@setup) if @setup

        while not @stopped do
          start = Time.now
          # TODO log beginning execution
          instance_eval(&@task) if @task
          # TODO log completed execution

          while (to_sleep = start + @interval - Time.now) > 0 and not @stopped
            sleep to_sleep
          end
        end
      end
    end
  end
end

