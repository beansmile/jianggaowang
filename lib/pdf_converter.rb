class PDFConverter
  # 转换 PDF 文件到图片
  # @param input [String] 待转换 PDF 文件的绝对路径
  # @param output_directory [String] 输出文件的保存目录
  # 以文件名命名生成的文件，并以“preview”开头
  def self.convert(input_file, output_directory)
    # TODO: 是否需要去除output_directory 目录下已经存在的图片
    FileUtils.mkdir_p(output_directory)  # 确保目录存在

    # IMPROVE: 支持参数可配置，改为 options 的接口风格
    MiniMagick::Tool::Convert.new do |convert|
      convert.merge! ["-density", "150", input_file]
      convert.merge! ["-quality", "85", "-antialias"]
      convert << "#{output_directory}/preview.jpg"
    end

    Dir.glob("#{output_directory}/preview*.jpg").count
  end
end
