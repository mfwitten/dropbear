static_prereqs := $(prereqs_dir)/static/include.mk

ifeq ($(dynamic_prereqs_M),)
  remove_dynamic_prereqs := $(NOTHING)
  include $(srcdir)/$(static_prereqs)
else
  prereq_targets = dynamic-prereqs $(dynamic_prereqs) \
                   static-prereqs $(static_prereqs) \
                   depends
  include $(srcdir)/$(prereqs_dir)/dynamic/include.mk
  include $(srcdir)/$(prereqs_dir)/build-static.mk
endif
