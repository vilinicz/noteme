worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

before_fork do |server, worker|
    Signal.trap 'TERM' do
        puts "Unicorn master intercepting TERM and sending myself QUIT instead. LOL ~(@_@)~"
        process.kill 'QUIT', Process.pid
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
    Signal.trap 'TERM' do
        puts "Unicorn worker intercepting TERM and doing nothing. Wait for ninja(master) to send QUIT"
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end