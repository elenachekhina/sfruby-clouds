class Cloud
  class NSFWDetector
    VISION_API_URL = "https://vision.googleapis.com/v1/images:annotate"

    LIKELIHOOD_VALUES = {
      "UNKNOWN" => 0,
      "VERY_UNLIKELY" => 1,
      "UNLIKELY" => 2,
      "POSSIBLE" => 3,
      "LIKELY" => 4,
      "VERY_LIKELY" => 5
    }.freeze

    THRESHOLDS = {
      "adult" => "UNLIKELY",
      "racy" => "POSSIBLE",
      "violence" => "UNLIKELY"
    }.freeze

    private attr_reader :image_blob, :api_key

    def initialize(cloud, api_key: GeminiConfig.api_key)
      @image_blob = cloud.image.blob
      @api_key = api_key
    end

    def check
      # Ignore if no API key
      return true if api_key.blank?

      content = Base64.strict_encode64(image_blob.download)

      json = {
        requests: [
          {
            image: {
              content:
            },
            features: [
              {
                type: "SAFE_SEARCH_DETECTION",
                maxResults: 1
              }
            ]
          }
        ]
      }

      response = HTTParty.post(
        "#{VISION_API_URL}?key=#{api_key}",
        body: json.to_json,
        headers: {"Content-Type" => "application/json"},
        timeout: 10
      )

      parse_vision_response(response)
    end

    def parse_vision_response(response)
      unless response.code == 200
        error_message = response.parsed_response.dig("error", "message") || "HTTP #{response.code}"
        raise error_message
      end

      data = response.parsed_response
      safe_search = data.dig("responses", 0, "safeSearchAnnotation")

      raise "No safe search data in response" unless safe_search

      THRESHOLDS.each do |kind, threshold|
        return false if LIKELIHOOD_VALUES[safe_search[kind]] > LIKELIHOOD_VALUES[threshold]
      end

      true
    end
  end
end
