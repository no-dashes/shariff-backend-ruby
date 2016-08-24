# Shariff Ruby Backend

A ruby-based [Shariff](https://github.com/heiseonline/shariff) backend.

## Using this backend

### Option 1: Mount in a Rails application

Since stand-alone servers are more likely to use one of the other backends, mounting the Ruby backend into an existing
Rack-based application like Ruby On Rails is the primary intended use.

To achieve this:

* add `gem 'shariff_backend'` to your `Gemfile`
* mount the app in your `config/routes.rb`

```ruby
mount ShariffBackend::App, at: '/shariff'
```

#### Checking your installation

Visit `/shariff?url=www.example.com` to get a JSON structure containing the share counts:

```json
{"facebook":321,"googleplus":23}
```

### Option 2: Running it stand-alone (i.e. Heroku)

- Create a `Gemfile` that at least references the `shariff_backend` gem:

  ```bash
  cat <EOF > Gemfile
  source 'https://rubygems.org'
  gem 'shariff_backend'
  EOF
  ```

- Install the `bundler` gem and run `bundler install`.

- Create a `config.ru` that runs `ShariffBackend::App`. 
  The one [from this repository](https://github.com/milgner/shariff-backend-ruby/blob/master/config.ru)
  would make a good start.

- Run it via `rackup`, [Heroku](https://devcenter.heroku.com/articles/rack) or a Ruby-based web server
  of your choice (Puma, Unicorn, Passenger etc).
