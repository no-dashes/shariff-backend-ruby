source 'https://rubygems.org'

gemspec

group :development, :test do

  # These are for my personal environment and not required for development
  # so I keep them here instead of the gemspec

  # Style checking & code metrics
  gem 'rubocop'
  # Documentation quality
  gem 'inch'

  # Nicer console
  gem 'pry-rails'
  gem 'pry-rescue'
  # Debugger
  if ENV['RUBYMINE']
    gem 'debase'
    gem 'ruby-debug-ide'
  else
    gem 'pry-byebug'
    gem 'pry-stack_explorer'
  end

  # git integration
  gem 'pry-git'
  # on-the-fly syntax highlighting
  gem 'coolline'
  gem 'awesome_print'
end
