RubyLLM.configure do |config|
  config.gemini_api_key = GeminiConfig.api_key
  config.log_level = Logger::DEBUG if ENV["DEBUG_LLM"].in?(%w[1 t true])
end
