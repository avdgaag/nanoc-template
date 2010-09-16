require 'digest/md5'

# A filter that simply filters any given content through JSlint and tells
# you when errors are found, raising a RuntimeError.
class JslintFilter < Nanoc3::Filter
  identifier :jslint
  def run(content, args = {})
    with_tempfile(content) do |f|
      check f
    end
  end

private

  # Use jslint to check a given file for javascript errors.
  #
  # This of course requires java installed on your system,
  # and a copy of the Rhino js engine and the lint program in
  # the /vendor directory.
  #
  # On error an exception is raised.
  def check(filename)
    raise ArgumentError, "Could not find file #{filename}" unless File.exists?(filename)

    cmd = 'java -cp %s org.mozilla.javascript.tools.shell.Main %s %s' % [
      path('vendor', 'js.jar'),
      path('vendor', 'fulljslint.js'),
      filename
    ]

    result = %x{#{cmd}}

    raise RuntimeError.new("JSLint found some problems in #{@item.identifier}:\n" + result) unless result =~ /^jslint: No problems found/
  end

  # Get the path to a file relative to the project root.
  def path(*parts)
    File.join(File.dirname(__FILE__), '..', *parts)
  end

  # For some given content create a temporary file,
  # yield the generated filename to the block and afterwards
  # remove the file again and return the original content.
  def with_tempfile(content)
    filename = Digest::MD5.hexdigest(content)
    file_path = path('tmp', filename)
    FileUtils.mkdir_p(File.dirname(file_path))
    File.open(file_path, 'w') do |f|
      f.write content
    end
    yield file_path
    File.unlink(file_path)
    content
  end
end
