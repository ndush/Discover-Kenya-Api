require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module TouristAttractionsApi
  class Application < Rails::Application
  
    config.load_defaults 7.0

   
    config.autoload_lib(ignore: %w[assets tasks])
    # config.autoload_paths += %W(#{config.root}/app/controllers)
    config.autoload_paths += %W(#{config.root}/app/controllers/users)
   
   
    config.eager_load_paths += %W(#{config.root}/app/controllers/users)

   
    config.api_only = true
    config.autoloader = :zeitwerk

   

    config.rgeo_factory = RGeo::Geos.factory(srid: 4326)

  
    RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |spatial_config|
      spatial_config.default = RGeo::Geos.factory(srid: 4326) 
      spatial_config.register(RGeo::Geos.factory(srid: 4326), geo_type: "point") 
    end
  end
end