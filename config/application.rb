require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TouristAttractionsApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    config.autoload_paths += %W(#{config.root}/app/controllers)
     config.autoload_paths << Rails.root.join('lib')
    # Eager load additional directories
    config.eager_load_paths += %W(#{config.root}/app/controllers/users)

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers, and assets when generating a new resource.
    config.api_only = true

    # Configure RGeo with SRID 4326 and set up spatial factories
    config.rgeo_factory = RGeo::Geos.factory(srid: 4326)

    # Register spatial factory for point geometry
    RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |spatial_config|
      spatial_config.default = RGeo::Geos.factory(srid: 4326) # Use the factory with SRID
      spatial_config.register(RGeo::Geos.factory(srid: 4326), geo_type: "point") # Register the factory directly
    end
  end
end