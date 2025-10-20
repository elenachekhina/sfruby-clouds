class Cloud
  class CardGenerator
    FLASH_IMAGE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent"

    private attr_reader :cloud, :api_key

    delegate :participant, to: :cloud

    def initialize(cloud, api_key: GeminiConfig.api_key)
      @cloud = cloud
      @api_key = api_key
    end

    def generate
      raise ArgumentError, "Gemini API key not configured" if api_key.blank?
      raise ArgumentError, "No photo attached" unless cloud.image.attached?

      parts = [
        {
          text: build_prompt
        },
        build_inline_data(cloud.image.blob.download, cloud.image.content_type),
        build_inline_data(Rails.public_path.join("sfruby_character.png").read, "image/png"),
        build_inline_data(Rails.public_path.join("sfruby_character_h.png").read, "image/png"),
        build_inline_data(Rails.public_path.join("sfruby_character_blue.png").read, "image/png")
      ]

      request = {
        contents: [
          {
            parts:
          }
        ],
        generationConfig: {
          responseModalities: ["image"],
          temperature: 1.0
        }
      }

      response = HTTParty.post(
        "#{FLASH_IMAGE_URL}?key=#{api_key}",
        body: request.to_json,
        headers: {"Content-Type" => "application/json"},
        timeout: 90
      )

      if response.success?
        process_response(response.parsed_response)
      else
        raise "Gemini API error: #{response.code} - #{response.body}"
      end
    end

    private

    def build_inline_data(io, content_type)
      {
        inlineData: {
          mimeType: content_type,
          data: Base64.strict_encode64(io)
        }
      }
    end

    def process_response(response)
      parts = response.dig("candidates", 0, "content", "parts")

      if parts.nil?
        raise "No parts found in response"
      end

      image_part = parts.find { it.dig("inlineData", "mimeType")&.start_with?("image/") }

      raise "No image data found in parts. Parts structure: #{parts.map(&:keys)}" unless image_part

      image_data = image_part["inlineData"]["data"]
      decoded_image = Base64.decode64(image_data)

      StringIO.new(decoded_image)
    end

    def build_prompt
      <<~PROMPT
        Create a SQUARE (1:1 aspect ratio, e.g., 1024x1024) image—required.
        Transform the provided photo (first image) into a cute and flattering cartoon character hanging out in the clouds with other clouds and the San Francisco Ruby Conference mascot, referencing branding and the style from the two supplied conference images (images 2 and 3).
        Include playful ruby elements, toy rails, toy trains; match the given style.

        The cartoon character must preserve recognizable details from the person's photo—face shape, hairstyle, skin tone, eye color, clothing, and notable features and items they hold—so that friends and colleagues can easily identify them, even as a cartoon.
        Do not use the actual photo; only the cartoon version in the conference style.

        Overlay this EXACT text, at top or bottom, in readable font (no splitting):

        Join #{participant.full_name} at the San Francisco Ruby Conference on November 19-21

        sfruby.com

        Embed the mascot and both conference logos, matching branding cues.
        Only output SQUARE format. If not square or if text missing, reject and regenerate.
        Make it fun, cute, and on-brand.

        You HAVE TO ENSURE that the overlay has THIS EXACT TEXT: Join #{participant.full_name} at the San Francisco Ruby Conference on November 19-21
        sfruby.com

      PROMPT
    end
  end
end
