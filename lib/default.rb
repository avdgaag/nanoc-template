require "bundler/setup"
require 'nanoc/cachebuster'
require 'erb'
include Nanoc::Helpers::CacheBusting
include Nanoc::Helpers::XMLSitemap
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Blogging
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Filtering
include Nanoc::Helpers::Tagging
include Nanoc::Helpers::Capturing
include Nanoc::Helpers::Text
include ERB::Util

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
  '<meta name="%s" content="%s">' % [h(key), h(value)] if value
end