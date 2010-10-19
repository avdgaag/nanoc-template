# This filter can process stylesheets and javascript files and concatenate
# them into a single file.
#
# That is, it can take a single file and expend references to other files into
# the contents of those files.
#
# So for CSS, the following:
#
#   @import url('reset.css');
#
# is replaced with the contents of reset.css:
#
#   * { margin: 0; padding: 0; }
#
# For javascript files there is no 'require' or 'import' statement, so we
# create our own with a simple comment:
#
#   // require jquery.js
#
# ...is replaced with the contents of jquery.js.
#
# Currently, this filters assumes you only use this feature for loading vendor
# code -- that is, that you do not write your own styles in multiple stylesheets.
# Any file that is referenced is looked up in the special top-level directory
# 'vendor'. So, the above  examples will actually try to load the files
# 'PROJECT_ROOT/vendor/reset.css' and 'PROJECT_ROOT/vendor/jquery.js'.
class ConcatFilter < Nanoc3::Filter
  identifier :concat

  def run(content, args = {})
    content.gsub(%r{^\s*(?:// require |@import url)\(?([a-zA-Z0-9_\-\.]+)(?:\);)?$}) do |m|
      load_file($1) || m
    end
  end

private

  def load_file(filename)
    path = File.join(File.dirname(__FILE__), '..', 'vendor', filename)
    return unless File.exists? path
    File.read(path)
  end
end
