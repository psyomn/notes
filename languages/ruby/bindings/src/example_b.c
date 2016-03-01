#include <ruby.h>

VALUE ExampleB = Qnil;

VALUE ret_i(VALUE);
VALUE ret_f(VALUE);
VALUE wop(VALUE, VALUE);
VALUE variadic(VALUE, VALUE);

void
Init_example_b() {
  ExampleB = rb_define_module("ExampleB");
  rb_define_method(ExampleB, "ret_i", ret_i, 0);
  rb_define_method(ExampleB, "ret_f", ret_f, 0);
  rb_define_method(ExampleB, "with_one_param", wop, 1);
  rb_define_method(ExampleB, "variadic", variadic, -2);
}

VALUE
ret_i(VALUE _self) {
  int x = 10;
  return INT2NUM(x);
}

VALUE
ret_f(VALUE _self) {
  double x = 12.12f;
  /* FIXME this blows up; hum.. */
  return NUM2DBL(INT2NUM(x));
}

VALUE
wop(VALUE _self, VALUE _param) {
  /** See also rb_eval_string_protect */
  // rb_eval_string("puts 'you passed a param!'");

  if (RB_TYPE_P(_param, T_STRING)) {
    return rb_str_new_cstr("You passed a string!\n");
  }
  if (RB_TYPE_P(_param, T_FLOAT)) {
    return rb_str_new_cstr("You passed a float!\n");
  }
  if (RB_TYPE_P(_param, T_SYMBOL)) {
    return rb_str_new_cstr("You passed a symbol!\n");
  }
  if (RB_TYPE_P(_param, T_NIL)) {
    return rb_str_new_cstr("You passed a nil!\n");
  }
  if (RB_TYPE_P(_param, T_ARRAY)) {
    return rb_str_new_cstr("You passed an array!\n");
  }
  if (RB_TYPE_P(_param, T_HASH)) {
    return rb_str_new_cstr("You passed a hash!\n");
  }
  if (RTEST(_param)) {
    return rb_str_new_cstr("You passed a truthy value!\n");
  }

  return Qnil;
}

VALUE
variadic(VALUE _self, VALUE _args) {
  if (RB_TYPE_P(_args, T_ARRAY)) {
    char buff[1024];
    sprintf(buff, "VARIADIC: number of params are: %ld", RARRAY_LEN(_args));
    return rb_str_new_cstr(buff);
  }
  return rb_str_new_cstr("You passed nothing");
}

