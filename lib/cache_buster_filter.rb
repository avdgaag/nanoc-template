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

  # List of extensions of files we want to cache-bust
  EXTENSIONS = %w{gif jpg jpeg png css bmp js}

  # Regex for finding all references to files to be cache busted in CSS files
  REGEX_CSS = /url\(('|"|)(([^'")]+)\.(#{EXTENSIONS.join('|')}))\1\)/i

  # Regex for finding all references to files to be cache busted in HTML files
  REGEX_HTML = /(href|src)="([^"]+(\.(?:#{EXTENSIONS.join('|')})))"/

  def run(content, args = {})
    stylesheet? ? bust_stylesheet(content) : bust_page(content)
  end

  # Get a unique fingerprint for a file's content. This currently uses
  # an MD5 hash of the file contents.
  #
  # @param <String> path is the path to the file to fingerprint.
  # @return <String> file fingerprint
  def self.hash(path)
    '-cb' + Digest::MD5.hexdigest(File.read(path))[0..8]
  end

private

  # See if the current item is a stylesheet.
  # @todo This might need more or better criteria
  # @return <Bool>
  def stylesheet?
    ['css', 'less'].include?(@item[:extension].to_s)
  end

  # Make a path relative to the site's content dir absolute
  # This works just like File.join, but makes the end result relative
  # to the project directory (the directory one level above this file).
  #
  # @param <String> path part of a path
  # @param ...
  # @return <String> path
  def content_path(*path)
    File.join(File.dirname(__FILE__), '..', 'content', *path)
  end

  # Add cache-busters to stylesheets
  #
  # @param <String> content of a stylesheet to rewrite
  # @return <String> rewritten content
  def bust_stylesheet(content)
    content.gsub(REGEX_CSS) do |m|
      real_path = content_path(File.dirname(@item.identifier), $2)
      if File.exists?(real_path)
        m.sub($2, $3 + CacheBusterFilter.hash(real_path) + '.' + $4)
      else
        m
      end
    end
  end

  # Add cache-busters to HTML pages
  # @todo improve the check for less-turned-css files. This might be sass or
  #   scss. We could check this using the identifier...
  #
  # @param <String> content of a page to rewrite
  # @return <String> rewritten content
  def bust_page(content)
    content.gsub(REGEX_HTML) do |m|
      attribute, path, extension = $1, $2, $3
      real_path = content_path(path)
      # when referring to css files, they might actually be .less files in
      # the sources
      real_path.sub!(/css$/, 'less') unless File.exists?(real_path)

      if File.exists?(real_path)
        %Q{#{attribute}="#{path.sub(extension, CacheBusterFilter.hash(real_path) + extension)}"}
      else
        m
      end
    end
  end
end
