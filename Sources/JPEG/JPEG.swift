import Clibjpeg
import Glibc


public func decodeJpeg(image: UnsafeMutableRawPointer, stride_y: Int, width image_width: Int, height image_height: Int, fileName: String) -> Bool {
  guard let file = fopen(fileName, "rb") else {
    return false
  }
  defer { fclose(file) }

  var err = jpeg_error_mgr()
  var info = jpeg_decompress_struct()
  info.err = jpeg_std_error(&err)

  jpeg_CreateDecompress(&info, JPEG_LIB_VERSION, MemoryLayout<jpeg_decompress_struct>.size)
  defer { jpeg_destroy_decompress(&info) }

  jpeg_stdio_src(&info, file)
  jpeg_read_header(&info, 1)

  info.out_color_space      = JCS_RGB
  info.out_color_components = 3
  info.output_components    = 3

  jpeg_start_decompress(&info)
  defer { jpeg_finish_decompress(&info) }

  let x = Int(info.output_width)
  let y = Int(info.output_height)
  if (x != image_width || y != image_height) {
    return false
  }

  let pixels = image.assumingMemoryBound(to: UInt8.self)

  while (info.output_scanline < info.output_height) {
    var rowPointer: JSAMPROW? = pixels + Int(info.output_scanline) * Int(stride_y)
    jpeg_read_scanlines(&info, &rowPointer, 1)
  }

  return true
}

public func encodeJpeg(image: UnsafeMutableRawPointer, stride_y: Int, width image_width: Int, height image_height: Int, fileName: String, quality: Int = 90) -> Bool {
  guard let outfile = fopen(fileName, "wb") else {
    print("can't open \(fileName)")
    return false
  }
  defer { fclose(outfile) }

  var cinfo = jpeg_compress_struct()
  var jerr = jpeg_error_mgr()

  cinfo.err = jpeg_std_error(&jerr)

  jpeg_CreateCompress(&cinfo, JPEG_LIB_VERSION, MemoryLayout<jpeg_compress_struct>.size)
  defer { jpeg_destroy_compress(&cinfo) }

  jpeg_stdio_dest(&cinfo, outfile)

  cinfo.image_width = JDIMENSION(image_width)
  cinfo.image_height = JDIMENSION(image_height)
  cinfo.input_components = 3
  cinfo.in_color_space = JCS_RGB

  jpeg_set_defaults(&cinfo)

  jpeg_set_quality(&cinfo, Int32(quality), 1)

  jpeg_start_compress(&cinfo, 1)
  defer { jpeg_finish_compress(&cinfo) }

  let pixels = image.assumingMemoryBound(to: UInt8.self)

  while (cinfo.next_scanline < cinfo.image_height) {
    var rowPointer: JSAMPROW? = pixels + Int(cinfo.next_scanline) * stride_y
    jpeg_write_scanlines(&cinfo, &rowPointer, 1)
  }

  return true
}
