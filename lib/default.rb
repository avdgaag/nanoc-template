require "bundler/setup"
include Nanoc3::Helpers::XMLSitemap

def meta_tag(key)
  value = @item[key] || @site.config[:meta_data][key]
  '<meta name="%s" content="%s">' % [key, value] if value
end