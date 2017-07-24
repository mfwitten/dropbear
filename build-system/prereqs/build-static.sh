#!/bin/bash

# Pass to `stdin' the concatenated contents of all the
# `*.d' files that must be considered.
#
# Pass as argument "$1" the full path to the source directory:
#
#   $ bash /path/to/this/program /path/to/source/directory <rules

main()
{(
  if (($# != 1)); then
    echo "bash $0 /path/to/source/directory <rules"
    exit 1
  fi

  local srcdir="$1"
  gather_the_rules_made_by_gcc | print_a_smaller_set_of_rules
)}

gather_the_rules_made_by_gcc()
{
  # Join separate lines into a one-line rule.
  sed -e '/\\$/{H;d;}' -e 'H;g;s/[[:space:]]*\\\n[[:space:]]*/ /g'
}

print_a_smaller_set_of_rules()
{
  declare -A targets_for_prereq
  declare -A prereqs_for_target_set
  sorted_target_sets=()

  associate_each_prereq_with_its_targets
  consolidate_duplicate_target_sets
  move_prereqs_from_supersets_to_subsets
  print_the_rules
}

associate_each_prereq_with_its_targets()
{
  local targets prereqs t p
  while IFS=: read targets prereqs; do
    for t in $targets; do
      [[ $t != *.o ]] && continue
      for p in $prereqs; do
        p_is_a_worthy_prereq || continue
        targets_for_prereq["$p"]+="$t"$'\n'
      done
    done
  done
}

consolidate_duplicate_target_sets()
{
  local prereq targets set

  for prereq in "${!targets_for_prereq[@]}"; do
    targets=($(printf %s "${targets_for_prereq["$prereq"]}" | sort -u))
    set=${targets[@]}' '
    if [[ -z ${prereqs_for_target_set["$set"]} ]]; then
      sorted_target_sets+=("${#targets[@]}:$set")
    fi
    prereqs_for_target_set["$set"]+="$prereq"$' \\\n'
  done

  unset targets_for_prereq
  sort_target_sets_largest_to_smallest
}

move_prereqs_from_supersets_to_subsets()
{
  local s s_set S S_size S_set S_set_new S_prereqs

  while there_are_movable_prereqs; do
    prereqs_for_target_set["$s_set"]+=$S_prereqs
    relegate_the_old_superset
  done
}

header=\
'# When supported, the build process instructs the C compiler
# or the C preprocessor to find the prerequisites of each
# object file (*.o) that is produced; this file was generated
# automatically from the results of that prerequisite search,
# and is meant to be used as a static substitute when such a
# search is not supported.
#
# In order to facilitate the review of alterations to this
# file, its content has been spread across as many lines
# as possible.'

print_the_rules()
{
  echo "$header"

  local s number_of_sets _ set target
  ((number_of_sets=${#sorted_target_sets[@]}))

  for ((s=number_of_sets-1; s>=0; --s)); do
    echo
    IFS=: read _ set <<<"${sorted_target_sets["$s"]}"
    for target in $set; do
      echo "$target \\"
    done
    echo ": \\"
    printf %s "${prereqs_for_target_set["$set"]}" | sort
  done
}

p_is_a_worthy_prereq()
{
  [[ $p == *.c ]] && return 1

  if [[ $p == /* ]]; then
    p=${p#"$srcdir"/}
    [[ $p == /* ]] && return 1
    p='$(srcdir)'/$p
  fi
}

sort_target_sets_largest_to_smallest()
{
  local IFS=$'\n'
  sorted_target_sets=($(
    for s in "${sorted_target_sets[@]}"; do
      echo "$s"
    done | sort -n -r
  ))
}

there_are_movable_prereqs()
{
  local number_of_sets
  ((number_of_sets=${#sorted_target_sets[@]}))

  for ((s=1; s<number_of_sets; ++s)); do
    for ((S=s-1; S>=0; --S)); do
      s_is_a_worthy_subset_of_S && return
    done
  done

  return 1
}

relegate_the_old_superset()
{
  unset prereqs_for_target_set["$S_set"]
  update_sorted_target_sets
  prereqs_for_target_set["$S_set_new"]+=$S_prereqs
}

s_is_a_worthy_subset_of_S()
{
  local s_size target

  IFS=: read s_size s_set <<<"${sorted_target_sets["$s"]}"
  IFS=: read S_size S_set <<<"${sorted_target_sets["$S"]}"

  S_prereqs=${prereqs_for_target_set["$S_set"]}
  S_set_new=$S_set

  # Try to remove the elements of s_set from S_set, and
  # thereby prove that s_set is a subset of S_set.
  for target in $s_set; do
    [[ $S_set_new =~ (^|^.* )"$target "(.*)$ ]] || return 1
    S_set_new=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
  done

  ((S_size-=s_size))
  ((${#s_set} > ${#S_prereqs})) # return status
}

update_sorted_target_sets()
{
  update_S_in_sorted_target_sets_or_remove_if_consolidating
  sort_target_sets_largest_to_smallest
}

update_S_in_sorted_target_sets_or_remove_if_consolidating()
{
  if [[ -n ${prereqs_for_target_set["$S_set_new"]} ]]; then
    unset sorted_target_sets["$S"]
  else
    sorted_target_sets["$S"]="$S_size:$S_set_new"
  fi
}

main "$@"
