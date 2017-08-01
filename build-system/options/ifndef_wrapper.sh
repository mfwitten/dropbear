#!/bin/sh

srcdir=$1

. "$srcdir"/build-system/options/regex.sh
wrap_the_define='\1#ifndef \3\n\1\2\n\1#endif'

sed "s/$define_line/$wrap_the_define/"
