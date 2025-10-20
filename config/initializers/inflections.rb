ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "API"
  inflect.acronym "JWT"
  inflect.acronym "OAuth"
  inflect.acronym "SMTP"
  inflect.acronym "AI"
  inflect.acronym "LLM"
  inflect.acronym "SF"
  inflect.acronym "NSFW"

  inflect.uncountable %w[debug mandrill]
end
