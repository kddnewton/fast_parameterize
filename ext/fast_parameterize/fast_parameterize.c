#include <ruby.h>
#include <ruby/encoding.h>
#include <stdlib.h>

// Makes an parameterized, lowercase form from the expression in the string.
static VALUE
str_parameterize(VALUE rb_string) {
  return rb_string;
}

// A singleton method calls with a string that delegates to str_parameterize to
// form a parameterized, lowercase form from the expression in the string.
static VALUE
rb_str_parameterize(VALUE self, VALUE rb_string) {
  return str_parameterize(rb_string);
}

// Hook into Ruby and define the FastParameterize::parameterize and
// String#parameterize.
void
Init_fast_parameterize(void) {
  VALUE rb_cFastParameterize = rb_define_module("FastParameterize");
  rb_define_singleton_method(rb_cFastParameterize, "parameterize", rb_str_parameterize, 1);
  rb_define_method(rb_cString, "parameterize", str_parameterize, 0);
}
