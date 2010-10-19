# The default nanoc sitemap helper function includes a lot in the sitemap that
# does not really belong there. This filter uses a quick regular expression
# to remove some of the clutter.
#
# You can use the 'sitemap_ignore_filter' setting in config.yaml to change
# what gets removed.
class CleanSitemapFilter < Nanoc3::Filter
  identifier :clean_sitemap
  def run(content, params = {})
    content.gsub(/<url>\s*<loc>[^<]+?(#{@site.config[:sitemap_ignore_filter]})<\/loc>\s*<lastmod>.+?<\/lastmod>\s*<\/url>\s*/m, '')
  end
end