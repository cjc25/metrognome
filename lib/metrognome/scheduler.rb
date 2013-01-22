module Metrognome
  class Scheduler
    attr_accessor :interval, :lock, :last

    def initialize interval, *variables
      self.interval = interval

      variables.each do |v|
        raise ArgumentError.new "All variables must be Strings or Symbols!" unless v.is_a? String or v.is_a? Symbol
        eval "class << self; attr_accessor :#{v}; end"
      end
    end

    def lock
      File.join(Rails.root, 'tmp', @lock)
    end

    def setup &block
      @setup = block
    end

    def task &block
      @task = block
    end

    def call_setup
      instance_eval &@setup if @setup
    end

    def call_task
      File.open(lock, File::RDWR | File::CREAT, 0600) do |file|
        break unless file.flock(File::LOCK_EX | File::LOCK_NB)
        self.last = Time.now
        instance_eval &@task if @task
      end
    end
  end
end

