# config/initializers/redis.rb

require 'redis'

$redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/0')

# Optionally, you can define a method to access Redis
def redis
  $redis
end