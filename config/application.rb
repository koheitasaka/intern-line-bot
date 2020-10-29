require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module RubyGettingStarted
  class Application < Rails::Application
    config.load_defaults 5.0
    config.autoload_paths += %W(#{config.root}/app/exceptions/**)
  end
end
