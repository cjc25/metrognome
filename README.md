# Metrognome

A simple repeating task scheduler for Rails applications

## Installation

Add this line to your application's Gemfile:

    gem 'metrognome'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install metrognome

## Usage

### Starting and Stopping

To start the metrognome, run:

    $ bundle exec rake metrognome:start

In production, use RAILS\_ENV to let Rails know to start the right environment:

    $ bundle exec rake RAILS_ENV=production metrognome:start

To stop the metrognome, run:

    $ bundle exec rake metrognome:stop

### Schedulers

Schedulers are registered with metrognome and run on a periodic basis.
Schedulers are `.rb` files read from the folder `config/metrognome`

#### Initialization and task

All schedulers are instances of Metrognome::Scheduler, initialized like:

```ruby
beeper = Metrognome::Scheduler.new(10.seconds)
```

The beeper task will be executed every 10 seconds beginning when the metrognome
starts. To define the task to execute, pass a block to `beeper.task`:

```ruby
beeper.task do
  puts "Beep!"
end
```

Finally, register the task with `Metrognome::Registrar.register`:

```ruby
Metrognome::Registrar.register beeper
```

#### Setup and local variables

Most schedulers can benefit from some persistence, or at least some setup. Let's
have our beeper keep track of how many times it's beeped.

Accessors can be declared when the scheduler is initialized:

```ruby
beeper = Metrognome::Scheduler.new(10.seconds, :counter)
```

The counter can be given an initial value by passing a block to `beeper.setup`:

```ruby
beeper.setup do
  self.counter = 0
end
```

Finally, the counter can be used in the task block:

```ruby
beeper.task do
  self.counter += 1
  logger.info "Beep! #{counter} time(s)"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request at cjc25/metrognome

TODO: Commit message/code style guidelines
