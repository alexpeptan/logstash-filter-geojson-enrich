# encoding: utf-8
require "logstash/filters/base"
require "rgeo"
require "rgeo/geo_json"
require "json"

# This  filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an .
class LogStash::Filters::LogstashFilterGeojsonEnrich < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #    {
  #     file => "[path]"
  #   }
  # }
  #
  config_name "logstash-filter-geojson-enrich-1"

  config :file, :validate => :string, :required => true
  config :coordinate_field, :validate => :string, :required => true
  config :map_field, :validate => :hash, :default => Hash.new, :required => false

  public
  def register
	if @file
		if File.zero?(@file)
			raise "file is empty"
		end
	
		file_content = File.read(@file)
		@data = JSON.parse(file_content)
		@factory = RGeo::Cartesian.factory
		
		@geom_list = []
		
		
		@data["features"].each do |feature|
			geom = feature
			geom["geometry"] = RGeo::GeoJSON.decode(feature["geometry"])
		
			if geom["geometry"].nil?
				puts "Geom nil: " + feature["properties"].to_s
			else
				@geom_list.append(geom)
			end
		end
	end
  end

  public
  def filter(event)
	@geom_list.each do |geom|

		x = event.get(coordinate_field + "[lat]")
		y = event.get(coordinate_field + "[lon]")
		is_inside_polygon = geom["geometry"].contains?(@factory.point(x, y))
		
		if is_inside_polygon
			@map_field.each do |src_field, dest_field|
				val = geom["properties"][src_field]
				if !val.nil?
					event.set(dest_field, val)
				end
			end
		end
	end

    filter_matched(event)
  end # def filter
end # class LogStash::Filters::LogstashFilterGeojsonEnrich
