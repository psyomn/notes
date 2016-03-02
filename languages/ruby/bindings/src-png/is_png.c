#include <png.h>
#include <ruby.h>

static VALUE m_is_png;

VALUE
check_file_png(VALUE _self, VALUE _filename) {
  if (!RB_TYPE_P(_filename, T_STRING)) {
    rb_raise(rb_eTypeError, "you need to provide a string");
  }

  char hd[8];
  char* fn = StringValueCStr(_filename);
  FILE* fd = fopen(fn, "rb");

  if (!fd) {
    rb_raise(rb_eStandardError, "no such file!");
  }

  int _bytes = fread(hd, 1, 8, fd);
  fclose(fd);

  if (!png_sig_cmp(hd, 0, 8))
    return Qtrue;
  else
    return Qfalse;

  return Qnil;
}

void Init_is_png() {
  m_is_png = rb_define_module("IsPng");
  rb_define_method(m_is_png, "is_png", check_file_png, 1);
}


