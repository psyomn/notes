require 'mkmf'

extension_name = 'is_png'

$LDFLAGS << " -lpng "

dir_config(extension_name)
create_makefile(extension_name)

have_library("png")
have_header("png.h")
have_func("png_sig_cmp")
