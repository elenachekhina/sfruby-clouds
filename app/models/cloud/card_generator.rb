class Cloud
  class CardGenerator
    private attr_reader :cloud, :api_key

    delegate :participant, to: :cloud

    def initialize(cloud)
      @cloud = cloud
    end

    def generate
      raise ArgumentError, "No photo attached" unless cloud.image.attached?

      chat = RubyLLM.chat(model: "gemini-2.5-flash-image")
        .with_temperature(1.0)
        .with_params(generationConfig: {responseModalities: ["image"]})

      response = chat.ask build_prompt, with: build_attachments
      raise "LLM error: #{response.raw.body.dig("candidates", 0, "finishMessage") || "no data"}" if response.content.blank?

      response.content[:attachments].first.source
    end

    private

    def build_attachments
      [
        cloud.image.blob,
        Rails.public_path.join("sfruby_character.png"),
        Rails.public_path.join("sfruby_character_h.png"),
        Rails.public_path.join("sfruby_character_blue.png")
      ]
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
