class PDFConverter
  # 转换 PDF 文件到图片
  # @param input [String] 待转换 PDF 文件的路径
  # @param output_directory [String] 输出文件的保存目录
  # @param file_name_prefix [String] 文件命名模式，默认“preview”
  # @return [Integer] 处理的页面数
  def self.convert(input, output_directory, file_name_prefix = "preview")
    FileUtils.mkdir_p(output_directory)  # 确保目录存在

    # IMPROVE: 支持参数可配置，改为 options 的接口风格
    MiniMagick::Tool::Convert.new do |convert|
      convert.merge! ["-density", "150", input]
      convert.merge! ["-quality", "85", "-antialias"]
      convert << "#{output_directory}/#{file_name_prefix}.jpg"
    end

    Dir.glob("#{output_directory}/#{file_name_prefix}-*.jpg").count
  end
end