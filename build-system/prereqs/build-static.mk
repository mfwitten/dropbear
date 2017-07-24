$(static_prereqs): $(dynamic_prereqs)
	@$(MKDIR_P) $(prereqs_dir)/static
	for f in $^; do cat "$$f"; done \
	  | $(srcdir)/$(prereqs_dir)/build-static.sh $(srcdir) \
	    1>$(static_prereqs)

.PHONY: static-prereqs
static-prereqs:
	@s=$(srcdir); \
	if [ -z "$$s" -o -n "$${s%%/*}" ]; then \
	  echo "Run \`make $@' only from an out-of-tree build directory."; \
	  exit 1; \
	fi; \
	rm -f $(static_prereqs) \
	  && $(MAKE) $(static_prereqs)
