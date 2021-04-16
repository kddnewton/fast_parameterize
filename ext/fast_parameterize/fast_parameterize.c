#include <ctype.h>
#include <ruby.h>
#include <ruby/encoding.h>

/**
 * This function works by maintaining a state machine that tracks which
 * characters are allowed at any given state, and reacting appropriately. The
 * state machine looks like:
 *
 *         ┌ N ┐                     ┌ C ┐
 *         │   v                     │   v
 *    ┌─────────────┐           ┌─────────────┐
 *    │             │           │             │
 * ──>│    START    │──── C ───>│     CHAR    │
 *    │             │           │             │
 *    └─────────────┘           └─────────────┘
 *                                  │     ^     
 *         ┌ N ┐                    │     │
 *         │   v                    │     │
 *    ┌─────────────┐               │     |
 *    │             │<─── N ────────┘     |
 *    │     SEP     │                     |
 *    │             │──── C ──────────────┘
 *    └─────────────┘
 *
 * Where C represents a character that is allowed in the output and N represents
 * a character that is not allowed in the output.
 */

// This is the current state of the state machine being used to compile the
// parameterized string.
enum state {
  STATE_START,
  STATE_CHAR,
  STATE_SEP
};

// This is used to tell if the given character is allowed to be part of the
// output string as opposed to being replaced by the separator.
static inline int ischar(int character) {
  return (
    (character >= 'a' && character <= 'z') ||
    (character >= 'A' && character <= 'Z') ||
    (character >= '0' && character <= '9') ||
    character == '-' || character == '_'
  );
}

// This is a function that preserves the same interface as tolower that can be
// swapped in its place in case the preserve_case option was set to true.
static int tosame(int character) {
  return character;
}

// Makes a parameterized, lowercase form from the expression in the string.
static VALUE parameterize(VALUE string, VALUE kwargs) {
  static ID keywords[2];
  CONST_ID(keywords[0], "separator");
  CONST_ID(keywords[1], "preserve_case");

  VALUE options[2] = { Qundef, Qundef };
  rb_get_kwargs(kwargs, keywords, 0, 2, options);

  // Configure the options based on the inputted keyword arguments
  const char *separator = options[0] == Qundef ? "-" : StringValueCStr(options[0]);
  size_t separator_size = strlen(separator);
  int(*tocase)(int) = options[1] == Qtrue ? tosame : tolower;

  // Set the initial state and build a buffer for the resulting string
  enum state state = STATE_START;
  char result[RSTRING_LEN(string) * separator_size];
  size_t size = 0;

  // Set up a couple of variables necessary for iterating through the string
  rb_encoding *encoding = rb_enc_from_index(ENCODING_GET(string));
  int codepoint_size;
  int character;

  // Determine the bounds of the string for our loop
  char *pointer = RSTRING_PTR(string);
  char *end = RSTRING_END(string);

  while (pointer < end) {
    character = rb_enc_codepoint_len(pointer, end, &codepoint_size, encoding);
    pointer += codepoint_size;

    switch (state) {
      case STATE_START:
        if (ischar(character)) {
          result[size++] = tocase(character);
          state = STATE_CHAR;
        }
        break;
      case STATE_CHAR:
        if (ischar(character)) {
          result[size++] = tocase(character);
        } else {
          state = STATE_SEP;
        }
        break;
      case STATE_SEP:
        if (ischar(character)) {
          strncpy(result + size, separator, separator_size);
          size += separator_size;

          result[size++] = tocase(character);
          state = STATE_CHAR;
        } else {
          state = STATE_SEP;
        }
        break;
    }
  }

  return rb_enc_str_new(result, size, encoding);
}

// FastParameterize::parameterize
static VALUE fast_parameterize(int argc, VALUE* argv, VALUE self) {
  VALUE string = Qnil;
  VALUE kwargs = Qnil;
  rb_scan_args(argc, argv, "10:", &string, &kwargs);

  return RB_TYPE_P(string, T_STRING) ? parameterize(string, kwargs) : Qnil;
}

// String#parameterize
static VALUE string_parameterize(int argc, VALUE* argv, VALUE self) {
  VALUE kwargs = Qnil;
  rb_scan_args(argc, argv, "00:", &kwargs);

  return parameterize(self, kwargs);
}

// Hook into Ruby and define the FastParameterize::parameterize and
// String#parameterize.
void Init_fast_parameterize(void) {
  VALUE rb_cFastParameterize = rb_define_module("FastParameterize");
  rb_define_singleton_method(rb_cFastParameterize, "parameterize", fast_parameterize, -1);
  rb_define_method(rb_cString, "parameterize", string_parameterize, -1);
}
