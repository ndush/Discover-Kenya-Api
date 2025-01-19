threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Use `bind` to specify the interface and port explicitly.
bind "tcp://127.0.0.1:3000"

# Allow Puma to be restarted by the `bin/rails restart` command.
plugin :tmp_restart

# Run the Solid Queue supervisor inside of Puma for single-server deployments
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Specify the PID file.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
