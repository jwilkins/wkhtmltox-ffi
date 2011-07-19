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

  attach_function(:wkhtmltoimage_init, [:uint], :uint)
  attach_function(:wkhtmltoimage_create_global_settings, [], :pointer)
  attach_function(:wkhtmltoimage_set_global_setting, [:pointer, :string, :string], :uint)
  attach_function(:wkhtmltoimage_create_converter, [:pointer, :pointer], :pointer)
  attach_function(:wkhtmltoimage_convert, [:pointer], :uint);
  attach_function(:wkhtmltoimage_destroy_converter, [:pointer], :uint)
  attach_function(:wkhtmltoimage_deinit, [], :uint)
end

module WkHtmlToX
  module Pdf
    # simplify imported names
    def self.init(use_graphics)
      wkhtmltopdf_init(use_graphics)
    end
    def self.create_global_settings
      wkhtmltopdf_create_global_settings
    end
    def set_global_setting
      wkhtmltopdf_set_global_setting
    end
    def create_object_settings
      wkhtmltopdf_create_object_settings 
    end
    def set_object_setting
      wkhtmltopdf_set_object_setting 
    end
    def create_converter
      wkhtmltopdf_create_converter 
    end
    def add_object
      wkhtmltopdf_add_object 
    end
    def convert
      wkhtmltopdf_convert 
    end
    def destroy_converter
      wkhtmltopdf_destroy_converter 
    end
    def deinit
      wkhtmltopdf_deinit 
    end
  end

  # clean interface
  def self.pdf(url, outfile)
    WkHtmlToX.wkhtmltopdf_init(0)
    gs = WkHtmlToX.wkhtmltopdf_create_global_settings();
    WkHtmlToX.wkhtmltopdf_set_global_setting(gs, "out", outfile);
    os = WkHtmlToX.wkhtmltopdf_create_object_settings();
    WkHtmlToX.wkhtmltopdf_set_object_setting(os, "page", url)
    c = WkHtmlToX.wkhtmltopdf_create_converter(gs)
    WkHtmlToX.wkhtmltopdf_add_object(c, os, nil)
    WkHtmlToX.wkhtmltopdf_convert(c)
    WkHtmlToX.wkhtmltopdf_destroy_converter(c)
    #WkHtmlToX.wkhtmltopdf_deinit();
  end

  def self.png(url, outfile)
    WkHtmlToX.wkhtmltoimage_init(0)
    gs = WkHtmlToX.wkhtmltoimage_create_global_settings();
    WkHtmlToX.wkhtmltoimage_set_global_setting(gs, "out", outfile);
    WkHtmlToX.wkhtmltoimage_set_global_setting(gs, "in", url);
    c = WkHtmlToX.wkhtmltoimage_create_converter(gs, nil)
    WkHtmlToX.wkhtmltoimage_convert(c)
    WkHtmlToX.wkhtmltoimage_destroy_converter(c)
    #WkHtmlToX.wkhtmltoimage_deinit();
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
  WkHtmlToX.png("http://github.com/jwilkins/wkhtmltox-ffi/", "wkhtmltox-ffi.png")
  WkHtmlToX.pdf("http://github.com/jwilkins/wkhtmltox-ffi/", "wkhtmltox-ffi.pdf")
end
