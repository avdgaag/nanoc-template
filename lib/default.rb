require_relative './export_sketch_filter'
require_relative './tags'
require_relative './convert_filter'

# use_helper Nanoc::Helpers::Blogging
# use_helper Nanoc::Helpers::Breadcrumbs
# use_helper Nanoc::Helpers::Capturing
# use_helper Nanoc::Helpers::ChildParent
# use_helper Nanoc::Helpers::Filtering
# use_helper Nanoc::Helpers::HTMLEscape
# use_helper Nanoc::Helpers::LinkTo
# use_helper Nanoc::Helpers::Rendering
# use_helper Nanoc::Helpers::Tagging
# use_helper Nanoc::Helpers::Text
use_helper Nanoc::Helpers::XMLSitemap
use_helper Tags

# Return all "content" items (HTML pages that are not hidden) for inclusion
# in the generated sitemap.
def content_items
  @items.select do |item|
    !item[:is_hidden] && (item.path.end_with?('.html') || item.path.end_with?('/'))
  end
end
