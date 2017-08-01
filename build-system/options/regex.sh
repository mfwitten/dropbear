maybe_space='[[:space:]]*'
space='[[:space:]]\{1,\}'
not_space='[^[:space:]]\{1,\}'
anything='.*'

indentation="\\($maybe_space\\)"
identifier="\\($not_space\\)"
define="\\(#define$space$identifier$space$anything\\)"
define_line="^$indentation$define\$"
