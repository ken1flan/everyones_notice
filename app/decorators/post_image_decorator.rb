module PostImageDecorator
  include CommonDecorator

  def markdown_string
    "![#{ title }](#{ image_url })"
  end
end
