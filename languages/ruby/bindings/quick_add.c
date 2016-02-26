#include <ruby.h>

VALUE QuickAdd = Qnil;

VALUE ret_i(VALUE);
VALUE ret_f(VALUE);
VALUE wop(VALUE, VALUE);

void
Init_quick_add() {
  QuickAdd = rb_define_module("QuickAdd");
  rb_define_method(QuickAdd, "ret_i", ret_i, 0);
  rb_define_method(QuickAdd, "ret_f", ret_f, 0);
  rb_define_method(QuickAdd, "with_one_param", wop, 1);
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
  else if (RB_TYPE_P(_param, T_FLOAT)) {
    return rb_str_new_cstr("You passed a float!\n");
  }
  else if (RB_TYPE_P(_param, T_SYMBOL)) {
    return rb_str_new_cstr("You passed a symbol!\n");
  }
  else if (RB_TYPE_P(_param, T_NIL)) {
    return rb_str_new_cstr("You passed a nil!\n");
  }
  else if (RB_TYPE_P(_param, T_ARRAY)) {
    return rb_str_new_cstr("You passed an array!\n");
  }
  else if (RB_TYPE_P(_param, T_HASH)) {
    return rb_str_new_cstr("You passed a hash!\n");
  }
  else if (RTEST(_param)) {
    return rb_str_new_cstr("You passed a truthy value!\n");
  }

  return Qnil;
}

