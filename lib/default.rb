require "bundler/setup"
require 'nanoc3/cachebuster'
include Nanoc3::Helpers::CacheBusting
include Nanoc3::Helpers::XMLSitemap
# include Nanoc3::Helpers::Rendering
# include Nanoc3::Helpers::Blogging
# include Nanoc3::Helpers::LinkTo
# include Nanoc3::Helpers::Filtering
# include Nanoc3::Helpers::Tagging
# include Nanoc3::Helpers::Capturing
# include Nanoc3::Helpers::Text

# Output a meta-tag for use in your site header. The key you supply is looked
# up in the configuration under 'meta_data'. You can override it on a per-item
# basis.
#
# Usage:
#
#   <%= meta_tag :keywords %>
#
# This will output:
#
#   <meta name="keywords" value="...">
#
# Here, '...' is either the value of @item[:keywords] or that of
# @site.config[:keywords].
def meta_tag(key)
  value = @item[key] || @site.config[:meta_data][key]
  '<meta name="%s" content="%s">' % [key, value] if value
end