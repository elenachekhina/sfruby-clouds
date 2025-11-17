module MarkdownHelper
  # claude
  def markdown_to_html(text)
    return "" if text.blank?

    Kramdown::Document.new(text).to_html.html_safe
  end
end
