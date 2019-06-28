# Binary filter to apply `convert` to convert an image to a different format.
# Requires imagemagick.
#
# Usage example:
#
#   compile '/*.png' do
#     filter :convert, to: 'ico'
#   end
#
class ConvertFilter < Nanoc::Filter
  identifier :convert
  type :binary

  def run(filename, params = {})
    system "convert #{filename} #{params.fetch(:to)}:#{output_filename}"
  end
end