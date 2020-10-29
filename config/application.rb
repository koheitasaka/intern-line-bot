require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module RubyGettingStarted
  class Application < Rails::Application
    config.load_defaults "6.0"
    config.autoloader = :classic
    config.autoload_paths += %W(#{config.root}/app/exceptions/**)
    config.autoload_paths += %W(#{config.root}/app/services)
  end
end
