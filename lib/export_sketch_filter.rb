# Filter for extracting an artboard from a Sketch file. Requires `sketchtool`, which
# ships with Sketch itself, to be in PATH. Use together with `SketchDataSource`.
class ExportSketchFilter < Nanoc::Filter
  identifier :export_sketch
  type :binary

  def run(filename, params = {})
    name = params.fetch(:name)
    Dir.mktmpdir do |dir|
      system "sketchtool export artboards '#{filename}' --item=#{name} --output='#{dir}' --save-for-web"
      FileUtils.mv File.join(dir, "#{name}.png"), output_filename
    end
  end
end
