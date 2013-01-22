namespace :metrognome do
  # TODO move PIDFILE into config
  module Metrognome
    PIDFILE = File.join 'tmp', 'metrognome.pid'
  end

  task :register => :environment do
    require 'metrognome'
    Dir[File.join(Rails.root, 'config', 'metrognome', '*.rb')].each do |file|
      require file
    end
  end

  desc 'Begin the metrognome scheduler'
  task :start => :register do
    unless File.exists? Metrognome::PIDFILE
      Signal.trap 'HUP', 'IGNORE'

      pid = fork do
        Rails.logger = Logger.new 'log/metrognome.log'
        Metrognome::Runner.start
      end

      Process.detach pid
      File.open(Metrognome::PIDFILE, File::CREAT | File::WRONLY | File::TRUNC, 0600) do |f|
        f.write pid
      end
    else
      $stderr.puts "#{Metrognome::PIDFILE} already exists. Is metrognome already running?"
    end
  end

  desc 'End the metrognome scheduler'
  task :stop do
    if File.exists? Metrognome::PIDFILE
      pid = 0
      begin
        pid = File.read(Metrognome::PIDFILE).to_i
      rescue
        $stderr.puts "Could not read the contents of #{Metrognome::PIDFILE}"
        return
      end
      raise "Bad PID in #{Metrognome::PIDFILE}" if pid == 0

      begin
        Process.kill :TERM, pid
      rescue Errno::EPERM
        $stderr.puts "Not permitted to kill process #{pid}"
        return
      rescue Errno::ESRCH
        $stderr.puts "Process #{pid} is not running"
      end

      File.delete Metrognome::PIDFILE
    else
      $stderr.puts "#{Metrognome::PIDFILE} does not exist"
    end
  end
end

