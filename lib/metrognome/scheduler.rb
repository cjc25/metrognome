module Metrognome
  class Scheduler
    attr_reader :thread

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

        until @stopped do
          start = Time.now
          Rails.logger.info "#{@description} beginning task execution."
          instance_eval(&@task) if @task
          Rails.logger.info "#{@description} completed task execution."
          # TODO log stopping task

          until @stopped do
            to_sleep = start + @interval - Time.now
            break if to_sleep <= 0 or Kernel.sleep(to_sleep) >= to_sleep
          end
        end
      end
    end
  end
end

