require 'json'
require 'digest'

# Use a Sketch file as a datasource, treating artboards as items.
# This allows us to extract artboards to individual images in our
# output site.
#
# This `DataSource` will list available artboards as items;
# use `ExportSketchFilter` to extract the artboards to files.
class SketchDataSource < Nanoc::DataSource
  identifier :sketch

  def up
    @checksum = Digest::SHA2.file(@config[:filename]).hexdigest
    @artboards = `sketchtool list artboards #{@config[:filename]}`
  end

  def items
    JSON.parse(@artboards)
      .fetch('pages')
      .find { |p| p['name'] == @config[:page] }
      .fetch('artboards')
      .map { |artboard| build_item(artboard) }
  end

  private

  def build_item(artboard)
    path = File.join(Dir.pwd, @config[:filename])
    identifier = "/#{artboard['name']}.png"
    new_item(path, artboard, identifier, binary: true, checksum_data: @checksum)
  end
end
