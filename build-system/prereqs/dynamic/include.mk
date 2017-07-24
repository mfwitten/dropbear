dynamic_prereqs = $(maxobjs:.o=.d)
remove_dynamic_prereqs = -rm -f $(dynamic_prereqs)

goals_involve_explicit_prereqs := $(filter $(prereq_targets),$(MAKECMDGOALS))

include $(srcdir)/$(prereqs_dir)/dynamic/include_recipes.mk

$(dynamic_prereqs): %.d : $(srcdir)/%.c $(options_headers)
	$(make-the-d-file-for-the-o-file) && \
	$(call add-the-d-file-to-the-d-file,$@,with failure on error)

.PHONY: dynamic-prereqs depends
dynamic-prereqs: $(dynamic_prereqs)
depends: dynamic-prereqs # the target name used by the ancients

ifneq ($(dynamic_prereqs_MD),)
# The sole use of this option is to optimize the process of
# generating dynamic prerequisites by combining it with the
# process of compiling an object file. If a `*.d' file already
# exists, then `make' will have already made sure that it is
# up-to-date; there is no purpose in re-doing that work, so the
# option is not used in that case.
#
$(allobjs): %.o: %.c
	d=$*.d; $(choose-whether-to-use-MD); \
	$(call run-CC-with-with-arg-and-output,$$MD,$@) \
	  || $(remove-d-file-if-necessary-and-then-fail); \
	if [ -n "$$MD" ]; then $(call add-the-d-file-to-the-d-file,$$d); fi
endif

# Unfortunately, every `include' directive essentially lists as a goal
# each file that is requested to be included; the result is that every
# such file (e.g., every `*.d' file) is checked for whether or not
# it needs to be made, even when the user doesn't care whether it's
# up-to-date.
#
# The correct solution is to make sure that a file is included only
# when its actually needed (e.g., to make sure that a `*.d' file is
# included only when that same file or its associated `*.o' file is
# deliberately being considered for making as part of normal target
# selection.
#
# Alas, such a solution is not [yet] possible, so the following simply
# covers the most common cases; the overriding logic is this sentence:
#
#     If `make' needs help figuring out whether to build a target,
#     then its associated `*.d' file is included.
#
# In particular, if an `*.o' or a `*.d' file does not exist, then `make'
# does not need any help, and thus it is not the case that a `*.d' file
# needs to be included; if an `*.o' or a `*.d' file does exist (which
# can be determined in general), and it has been selected as a target
# (which, sadly, cannot yet be determined in general), then it is the
# case that an associated `*.d' file needs to be included.
#

goals_that_need_prereqs := $(filter-out  \
  $(targets_without_dynamic_prereqs),    \
  $(or $(MAKECMDGOALS),$(.DEFAULT_GOAL)) \
)

ifneq ($(goals_that_need_prereqs),)

  include $(srcdir)/$(prereqs_dir)/dynamic/include_choosers.mk

  dynamic_prereqs_to_include := $(NOTHING)

  # Goals explicitly include various final programs:
  $(foreach p,$(maxprograms),         \
    $(call includes-for-program,$(p)) \
  )

  # Goals explicitly include `*.o' and `*.d' files:
  $(call includes-for,%.o %.d,filtered_goals)

  # Goals include something else:
  ifneq ($(goals_that_need_prereqs),)
    $(call includes-for-these-raw-o-or-d-targets, \
      $(allobjs)                                  \
      $(dynamic_prereqs)                          \
    )
  endif

  ifneq ($(dynamic_prereqs_to_include),)
    ifeq ($(or $(MAKE_RESTARTS),$(goals_involve_explicit_prereqs)),)
      $(call notify,Handling dynamic prerequisites...)
    endif
    include $(sort $(dynamic_prereqs_to_include))
  endif

endif
