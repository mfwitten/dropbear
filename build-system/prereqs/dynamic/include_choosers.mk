define includes-for-these-raw-o-or-d-targets
  $(eval $(call commands-for-includes-for-these-raw-o-or-d-targets,$(1)))
endef
define commands-for-includes-for-these-raw-o-or-d-targets
    o_or_d_targets_that_exist := $$(wildcard $(1))
    ifeq ($(dynamic_prereqs_to_include),)
      dynamic_prereqs_to_include := $$(o_or_d_targets_that_exist:.o=.d)
    else
      dynamic_prereqs_to_include += $$(o_or_d_targets_that_exist:.o=.d)
    endif
endef

includes-for-program = $(call includes-for,$(1)$(EXEEXT),$(1)objs)
includes-for = $(call raw-includes-for,$(1),$$($(2)))
raw-includes-for = $(eval $(call commands-for-includes-for,$(1),$(2)))

define commands-for-includes-for
  possible_goals := $(1)
  filtered_goals := $$(filter $$(possible_goals),$$(goals_that_need_prereqs))
  ifneq ($$(filtered_goals),)
    $$(call includes-for-these-raw-o-or-d-targets,$(2))
    goals_that_need_prereqs := $$(filter-out $$(filtered_goals),$$(goals_that_need_prereqs))
  endif
endef
