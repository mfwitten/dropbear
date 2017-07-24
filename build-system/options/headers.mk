options_h := $(srcdir)/$(options_headers_dir)options.h

config_raw_h := $(options_headers_dir)config-raw.h
config_h := $(srcdir)/$(options_headers_dir)config.h

localoptions_h := $(options_headers_dir)localoptions.h

default_options_h_name := default_options.h
default_options_h := $(options_headers_dir)$(default_options_h_name)
default_options_h_in := $(srcdir)/$(default_options_h).in

sysoptions_h := $(srcdir)/$(options_headers_dir)sysoptions.h

options_headers := $(options_h) $(config_h) $(config_raw_h) \
                   $(localoptions_h) $(default_options_h) $(sysoptions_h)
