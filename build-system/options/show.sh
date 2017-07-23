#!/bin/sh

# The following variables should be in the environment:
#
#   * CPP      : The C Prepprocessor
#   * CPPFLAGS : The command line options to pass to "$CPP"

srcdir=$1

. "$srcdir"/build-system/options/regex.sh
QoptionQ_option='"\3" \3'

print_option_defines()
{
  sed -n "s/$define_line/$QoptionQ_option/p" \
         default_options.h "$srcdir"/sysoptions.h
}

print_preprocessable_list()
{
  echo '#include "options.h"'
  print_option_defines
}

preprocess_list_and_remove_quotes()
{
  $CPP $CPPFLAGS -P - | sed 's/^"\([^"]*\)"/\1/'
}

display_list()
{
  max=0; options=

  while read option value; do
    eval "[ \"\${$option}\" ] && continue"
    options="$options $option"
    eval $option=\$value
    length=$(printf %s "$option" | wc -m)
    ((length > max)) && ((max=length))
  done

  for o in $options; do
    eval "printf '%-${max}s %s\n' \"\$o\" \"\${$o}\""
  done
}

print_preprocessable_list | preprocess_list_and_remove_quotes | display_list
