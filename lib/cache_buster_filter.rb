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
  EXTENSIONS = %w{gif jpg jpeg png css bmp js scss sass coffee less}

  # Regex for finding all references to files to be cache busted in CSS files
  REGEX_CSS = /url\(('|"|)(([^'")]+)\.(#{EXTENSIONS.join('|')}))\1\)/i

  # Regex for finding all references to files to be cache busted in HTML files
  REGEX_HTML = /(href|src)="([^"]+(\.(?:#{EXTENSIONS.join('|')})))"/

  # Custom exception that can be raised by #source_path
  NoSuchSourceFile = Class.new(Exception)

  # Custom exception that can be raised by #source_path when trying to rewrite
  # the name of a file that will not be cache busted and should hence be
  # left alone.
  NoCacheBusting = Class.new(Exception)

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

  # Test if we want to filter the output filename for a given item.
  # This is logic used in the Rules file, but doesn't belong there.
  #
  # @param <Item> item is the item to test
  # @return <Boolean>
  def self.should_filter?(item)
    EXTENSIONS.include? item[:extension]
  end

private

  # See if the current item is a stylesheet.
  #
  # Apart from regular .css-files, this method will consider any file
  # with an extension that is mapped to 'css' in the filter_extensions
  # setting in config.yaml to be a CSS file.
  #
  # @return <Bool>
  def stylesheet?
    @site.config[:filter_extensions].select do |k, v|
      v == 'css'
    end.flatten.uniq.map do |k|
      k.to_s
    end.include?(@item[:extension].to_s)
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
      quote, filename, basename, extension = $1, $2, $3, $4
      begin
        real_path = content_path(source_path(filename))
        m.sub(filename, basename + CacheBusterFilter.hash(real_path) + '.' + extension)
      rescue NoCacheBusting, NoSuchSourceFile
        m
      end
    end
  end

  # Add cache-busters to HTML pages.
  #
  # Since not every file referenced in the output is an actual input item,
  # we use {@link source_path} to get to the original input item for that
  # reference.
  #
  # If we cannot find an input item for the given reference, we leave the
  # reference alone. If we do, we add a cache buster to its filename.
  #
  # @see #source_path
  # @param <String> content of a page to rewrite
  # @return <String> rewritten content
  def bust_page(content)
    content.gsub(REGEX_HTML) do |m|
      attribute, path, extension = $1, $2, $3
      begin
        real_path = content_path(source_path(path))
        %Q{#{attribute}="#{path.sub(extension, CacheBusterFilter.hash(real_path) + extension)}"}
      rescue NoSuchSourceFile, NoCacheBusting
        m
      end
    end
  end

  # Try to find the source path of a referenced file.
  #
  # This will use Nanoc's routing rules to try and find an item whose output
  # path matches the path given, which is a source reference. It returns
  # the path to the content file if a match is found.
  #
  # As an example, when we use the input file "assets/styles.scss" for our
  # stylesheet, then we refer to that file in our HTML as "assets/styles.css".
  # Given the output filename, this method will return the input filename.
  #
  # @raises NoSuchSourceFile when no match is found
  # @param <String> path is the reference to an asset file from another source
  #   file, such as '/assets/styles.css'
  # @return <String> the path to the content file for the referenced file,
  #   such as '/assets/styles.scss'
  def source_path(path)
    path = absolutize(path)

    matching_item = @items.find do |item|
      item.path.sub(/-cb[a-zA-Z0-9]{9}(?=\.)/, '') == path
    end

    # Make sure the reference is left alone if we cannot find a source file
    # to base the fingerprint on, or if the file for some reason has no
    # cache busting applied to it (for example, when it is manually overriden
    # in the Rules file.)
    raise NoSuchSourceFile, 'no source file found matching ' + path unless matching_item
    raise NoCacheBusting, 'there is no cache busting applied to ' + matching_item.identifier unless matching_item.path =~ /-cb[a-zA-Z0-9]{9}(?=\.)/

    # Return the path to the source file in question without the starting content
    # part, since that is added by #content_path
    matching_item[:content_filename].sub(/^content\//, '')
  end

  # Get the absolute path to a file, whereby absolute means relative to the root.
  #
  # When we are trying to get to a source file via a referenced filename,
  # that filename may be absolute (relative to the site root) or relative to
  # the file itself. In the latter case, our file detection would miss it.
  # We therefore rewrite any reference not starting with a forward slash
  # to include the full path of the referring item.
  #
  # @example Using an absolute input path in 'assets/styles.css'
  #   absolutize('/assets/logo.png') # => '/assets/logo.png'
  # @example Using a relative input path in 'assets/styles.css'
  #   absolutize('logo.png') # => '/assets/logo.png'
  #
  # @param <String> path is the path of the file that is referred to in
  #   an input file, such as a stylesheet or HTML page.
  # @return <String> path to the same file as the input path but relative
  #   to the site root.
  def absolutize(path)
    return path if path =~ /^\//
    File.join(File.dirname(item[:content_filename]), path).sub(/^content/, '')
  end
end

