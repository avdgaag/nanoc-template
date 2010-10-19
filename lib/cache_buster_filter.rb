# The cache buster filter rewrites references to external files, so that the
# filenames include a timestamp. This creates a unique filename that will
# change whenever the file is changed.
#
# This allows you to use far-future expires headers to fully benefit from
# client-side caching.
#
# We do not simply append a query string, as this might sometimes trigger
# proxies to not cache the results.
#
# Note: this requires you to use .htaccess rewrites to point the
# filenames-with-timestamps back into normal filenames.
class CacheBusterFilter < Nanoc3::Filter
  identifier :cache_buster

  REGEX_CSS = /url\(('|"|)(([^'")]+)\.(gif|jpe?g|png|css|bmp))\1\)/i
  REGEX_HTML = /(href|src)="([^"]+(\.(?:png|gif|js|jpe?g|css)))"/

  def run(content, args = {})
    stylesheet? ? bust_stylesheet(content) : bust_page(content)
  end

private

  # See if the current item is a stylesheet.
  # @todo This might need more or better criteria
  def stylesheet?
    ['css', 'less'].include?(@item[:extension].to_s)
  end

  # Get a nicely formatted timestamp for a file
  def mtime(path)
    File.mtime(path).strftime('%Y%m%d%H%m')
  end

  # Make a path relative to the site's content dir absolute
  def content_path(*path)
    File.join(File.dirname(__FILE__), '..', 'content', *path)
  end

  # Add cache-busters to stylesheets
  def bust_stylesheet(content)
    content.gsub(REGEX_CSS) do |m|
      real_path = content_path(File.dirname(@item.identifier), $2)
      if File.exists?(real_path)
        m.sub($2, $3 + '-cb' + mtime(real_path) + '.' + $4)
      else
        m
      end
    end
  end

  # Add cache-busters to HTML pages
  # @todo improve the check for less-turned-css files. This might be sass or
  #   scss. We could check this using the identifier...
  def bust_page(content)
    content.gsub(REGEX_HTML) do |m|
      attribute, path, extension = $1, $2, $3
      real_path = content_path(path)
      # when referring to css files, they might actually be .less files in
      # the sources
      real_path.sub!(/css$/, 'less') unless File.exists?(real_path)

      if File.exists?(real_path)
        %Q{#{attribute}="#{path.sub(extension, '-cb' + mtime(real_path) + extension)}"}
      else
        m
      end
    end
  end
end
