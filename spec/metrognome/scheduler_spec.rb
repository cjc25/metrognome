require 'spec_helper'
require 'active_support/time'

describe Metrognome::Scheduler do
  before do
    @dummy_scheduler = Metrognome::Scheduler.new 1.minute, 'Test scheduler'
    @dummy_scheduler.setup { @task_counter = 0 }
    @dummy_scheduler.task do
      if @task_counter == 5
        self.stop
      else
        @task_counter += 1
      end
    end

    @slept = 0
    Kernel.stub(:sleep) do |arg|
      # Make sure we're only sleeping up to the schedule time.
      arg.should be < 1.minute
      @slept += 1
      arg + 1  # Always break out of the sleep loop.
    end

    # Metrognome should run in a Rails app, so set the logger we use.
    Rails.logger = Logger.new nil
  end

  it 'should count to 5' do
    @dummy_scheduler.run
    Thread.pass while @dummy_scheduler.thread.alive?
    @slept.should == 5
    @dummy_scheduler.instance_eval { @task_counter }.should == 5
  end

  it 'should exit without exception' do
    @dummy_scheduler.run
    Thread.pass while @dummy_scheduler.thread.alive?

    # The scheduler thread status is nil on exit due to exception.
    @dummy_scheduler.thread.status.should === false
  end
end
