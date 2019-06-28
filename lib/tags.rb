module Tags
  # Generate a `<link>` tag pointing its `href` attribute to the output
  # path of an item.
  #
  # Example:
  #
  #   link_tag('/site.webmanifest', rel: 'manifest')
  #   # => <link href="/site.webmanifest" rel="manifest">
  def link_tag(identifier, attrs = {})
    "<link #{to_attributes(attrs.merge href: item_path(identifier))} />"
  end

  # Shortcut method to use `link_tag` to link to a stylesheet.
  def stylesheet_tag(identifier)
    link_tag(identifier, rel: 'stylesheet')
  end

  # Generate a `<script>` tag pointing to the output path of an item
  # with the given identifier.
  def script_tag(identifier)
    "<script src=\"#{item_path(identifier)}\"></script>"
  end

  private

  def item_path(identifier)
    @items[identifier].path
  end

  def to_attributes(attrs)
    attrs.map { |(key, value)| "#{key}=\"#{value}\"" }.join(' ')
  end
end
