run-CC-with-with-arg-and-output = $(CC) $(1) $(CPPFLAGS) $(CFLAGS) -c $< -o $(2)
run-CPP-to-make-d-file = $(CPP) $(dynamic_prereqs_M) $(CPPFLAGS) $< >$@
define add-the-d-file-to-the-d-file
{ \
  d=$(1) temp=$$d.$$$$; \
  sed "s,:, $$d:," "$$d" >"$$temp" && mv -f "$$temp" "$$d" \
    || { $(if ($2),s=$$?;) rm -f "$$d" "$$temp"; $(if $(2),exit $$s;) }; \
}
endef

$(dynamic_prereqs): private QUIET:=$(if $(goals_involve_explicit_prereqs),,@)

make-the-d-file-for-the-o-file = $(QUIET)$(run-CPP-to-make-d-file)
ifneq ($(dynamic_prereqs_MD),)
  ifeq ($(goals_involve_explicit_prereqs),)
    define make-the-d-file-for-the-o-file
    { \
      o=$*.o; \
      $(call run-CC-with-with-arg-and-output,$(dynamic_prereqs_MD),"$$o") \
        || { rm -f "$$o"; $(run-CPP-to-make-d-file); }; \
    }
    endef
  endif
endif

choose-whether-to-use-MD = { [ -f "$$d" ] && MD= || MD=$(dynamic_prereqs_MD); }
define remove-d-file-if-necessary-and-then-fail
{ \
  s=$$?; \
  if [ -n "$$MD" ]; then \
    rm -f "$$d"; \
  fi; \
  exit "$$s"; \
}
endef
