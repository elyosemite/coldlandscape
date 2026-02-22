require "json"
require "net/http"
require "uri"

module Weather
  BASE_URL = "https://api.open-meteo.com/v1/forecast"

  Coordinates = Struct.new(:lat, :lon, keyword_init: true)

  class Error < StandardError; end
  class NetworkError < Error; end
  class ParseError < Error; end

  class Client
    TEMPERATURE_UNIT = "celsius"
    WIND_SPEED_UNIT  = "kmh"

    def initialize(coordinates)
      @coords = coordinates
    end

    def current
      data = fetch_data
      parse(data)
    rescue JSON::ParserError => e
      raise ParseError, "Invalid JSON: #{e.message}"
    rescue SocketError, Net::OpenTimeout => e
      raise NetworkError, "Connection failed: #{e.message}"
    end

    private

    def fetch_data
      uri = build_uri
      response = Net::HTTP.get_response(uri)
      raise NetworkError, "HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    end

    def build_uri
      params = {
        latitude:        @coords.lat,
        longitude:       @coords.lon,
        current_weather: true,
        temperature_unit: TEMPERATURE_UNIT,
        windspeed_unit:   WIND_SPEED_UNIT
      }
      uri = URI(BASE_URL)
      uri.query = URI.encode_www_form(params)
      uri
    end

    def parse(data)
      cw = data.dig("current_weather") or raise ParseError, "Missing current_weather"
      {
        temperature: cw["temperature"],
        wind_speed:  cw["windspeed"],
        wind_dir:    cw["winddirection"],
        is_day:      cw["is_day"] == 1,
        fetched_at:  Time.now
      }
    end
  end
end

coords = Weather::Coordinates.new(lat: -23.55, lon: -46.63)
client = Weather::Client.new(coords)

begin
  result = client.current
  puts "Temperature : #{result[:temperature]}°C"
  puts "Wind speed  : #{result[:wind_speed]} km/h"
  puts "Is daytime  : #{result[:is_day]}"
rescue Weather::Error => e
  warn "Weather error: #{e.message}"
end
