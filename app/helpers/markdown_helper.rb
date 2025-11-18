module MarkdownHelper
  # claude
  def markdown_to_html(text)
    return "" if text.blank?

    sanitize(Kramdown::Document.new(text).to_html)
  end
end
