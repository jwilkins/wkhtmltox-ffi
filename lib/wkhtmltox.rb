require 'rubygems'
require 'ffi'

#http://www.cs.au.dk/~jakobt/libwkhtmltox_0.10.0_doc/
#wkhtmltoimage_init is called.
#A wkhtmltoimage_global_settings object is creating by calling wkhtmltoimage_create_global_settings.
#Setting for the conversion are set by multiple calls to wkhtmltoimage_set_global_setting.
#A wkhtmltoimage_converter object is created by calling wkhtmltoimage_create_converter, which consumes the global_settings instance.
#A number of callback function are added to the converter object.
#The conversion is performed by calling wkhtmltoimage_convert.
#The converter object is destroyed by calling wkhtmltoimage_destroy_converter.

module WkHtmlToX
  # minimal imports
  extend FFI::Library
  ffi_lib "/lib/libwkhtmltox.so"

  attach_function(:wkhtmltopdf_init, [:uint], :uint)
  attach_function(:wkhtmltopdf_create_global_settings, [], :pointer)
  attach_function(:wkhtmltopdf_set_global_setting, [:pointer, :string, :string], :uint)
  attach_function(:wkhtmltopdf_create_object_settings, [], :pointer)
  attach_function(:wkhtmltopdf_set_object_setting, [:pointer, :string, :string], :uint)
  attach_function(:wkhtmltopdf_create_converter, [:pointer], :pointer)
  attach_function(:wkhtmltopdf_add_object, [:pointer, :pointer, :pointer], :uint)
  attach_function(:wkhtmltopdf_convert, [:pointer], :uint);
  attach_function(:wkhtmltopdf_destroy_converter, [:pointer], :uint)
  attach_function(:wkhtmltopdf_deinit, [], :uint)
end

module WkHtmlToX
  # simplify imported names
  def self.init(use_graphics)
    wkhtmltopdf_init(use_graphics)
  end
=begin
  alias :wkthmltopdf_create_global_settings :create_global_settings
  alias :wkhtmltopdf_set_global_settingp :set_global_setting
  alias :wkhtmltopdf_create_object_settings :create_object_settings
  alias :wkhtmltopdf_set_object_setting :set_object_setting
  alias :wkhtmltopdf_create_converter :create_converter
  alias :wkhtmltopdf_add_object :add_object
  alias :wkhtmltopdf_convert :convert
  alias :wkhtmltopdf_destroy_converter :destroy_converter
  alias :wkhtmltopdf_deinit :deinit
=end

  # clean interface
  def self.pdf(url, outfile)
    WkHtmlToX.init(0)
    WkHtmlToX.wkhtmltopdf_init(0)
    gs = WkHtmlToX.wkhtmltopdf_create_global_settings();
    WkHtmlToX.wkhtmltopdf_set_global_setting(gs, "out", outfile);
    os = WkHtmlToX.wkhtmltopdf_create_object_settings();
    WkHtmlToX.wkhtmltopdf_set_object_setting(os, "page", url)
    c = WkHtmlToX.wkhtmltopdf_create_converter(gs)
    WkHtmlToX.wkhtmltopdf_add_object(c, os, nil)
    WkHtmlToX.wkhtmltopdf_convert(c)
    WkHtmlToX.wkhtmltopdf_destroy_converter(c)
    WkHtmlToX.wkhtmltopdf_deinit();
  end
end

if __FILE__ == $0
=begin
  puts WkHtmlToX.init(0)
  gs = WkHtmlToX.wkhtmltopdf_create_global_settings();
  puts "gs: #{gs}"
  puts WkHtmlToX.wkhtmltopdf_set_global_setting(gs, "out", "test.pdf");
  os = WkHtmlToX.wkhtmltopdf_create_object_settings();
  puts "os: #{os}"
  puts WkHtmlToX.wkhtmltopdf_set_object_setting(os, 
    "page", "http://doc.trolltech.com/4.6/qstring.html")
  c = WkHtmlToX.wkhtmltopdf_create_converter(gs)
  puts "c: #{c}"

  WkHtmlToX.wkhtmltopdf_add_object(c, os, nil)
  WkHtmlToX.wkhtmltopdf_convert(c)
  WkHtmlToX.wkhtmltopdf_destroy_converter(c)

  puts WkHtmlToX.wkhtmltopdf_deinit();
=end
  WkHtmlToX.pdf("http://github.com/jwilkins/wkhtmltox-ffi/", "wkhtmltox-ffi.pdf")
end
