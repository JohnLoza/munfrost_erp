# frozen_string_literal: true

require "uri"
require "json"
require "net/http"

module Cyberpuerta
  class Sync < ApplicationService
    def initialize(payload)
      @payload = payload
    end

    def call
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Accept"] = "application/json"
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{ENV['CYBERPUERTA_TOKEN']}"
      request.body = JSON.dump(@payload)
      Rails.logger.debug("Cyberpuerta sync with payload: \n#{@payload.to_json}")

      response = https.request(request)
      Rails.logger.debug("Cyberpuerta response: #{response.read_body}")
      parsed_response = JSON.parse(response.read_body)
      return if parsed_response['message'] == 'Products uploaded successfully!'

      raise(StandardError, parsed_response['message'])
    end

    private

    def url
      @url ||=
        if Rails.env.production?
          URI("https://cyberpuerta.mx/api/provider/articles/full-catalog")
        else
          URI("https://base.cyberpuerta.mx/api/provider/articles/full-catalog")
        end
    end
  end
end
