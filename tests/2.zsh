#!/usr/bin/env zsh

# enables the 'colored' function
source "$ZSH/plugins/colored-man-pages/colored-man-pages.plugin.zsh"

# ——————————————————————————————————————————————————————————————————————————— #

man help tldr () {
  local -r _tldr_cmd='command tldr --color=always'

  # if the input is 'man all', or 'help -l', etc., then pass the
  #  job onto one of those dedicated functions
  [[ "$1" =~ '-l|--list|all' ]] && { "man::list_all::$0"; return $?; }
  # otherwise, if the input is 'tldr', then I assume that I actually meant
  #  'tldr', so run that command as-is
  [[ "$0" == 'tldr' ]] && { "${(z)_tldr_cmd}" "$@"; return $?; }

  # finally, if $1,$2 weren't 'man all', and $0 wasn't 'tldr', pass it on
  # to the man intercept function, which handles both 'man', and 'help'
  man::main "$@"
}

# ——————————————————————————————————————————————————————————————————————————— #

man::main() {

  local -ra _ALL_HELP_FUNCS=(
    'alias'         'autoload'      'bg'            'bindkey'       'break'
    'builtin'       'bye'           'cap'           'cd'            'echo'
    'clone'         'colon'         'command'       'comparguments' 'compcall'
    'compctl'       'compdescribe'  'compfiles'     'compgroups'    'compquote'
    'comptags'      'comptry'       'compvalues'    'continue'      'declare'
    'dirs'          'disable'       'disown'        'dot'           'echo'
    'emulate'       'enable'        'eval'
  )

  # Note: these commands will have to be split back up into
  #  separate commands and args using the (z) parameter flag
  local -rA _command=(
    [help]='run-help'
     [man]='colored command man'
    [tldr]='command tldr --color=always'
  )

  local -i 10 section
  [[ "$1" =~ '^\d+$' ]] && { section=$1; shift; }
  local -r page="$1"

  local -ri do_run_help=$(( ${_ALL_HELP_FUNCS[(Ie)$page]} ))

  local -r _base_err="No entry for '$page'"
  local -r _section_err="$_base_err in section $section"
  local -r _no_match_err="$_base_err\nChecked 'man', 'run-help', and 'tldr'"

  # if the inputted page is one of the pages that's covered by run-help, then
  #  use one of those.
  # we're doing it this way, bc run-help has a rly annoying feature where it'll
  #  run 'man' on failure, which messes w our whole plan
  (( do_run_help && ! section )) && { "${(z)_command[help]}" "$page"; return; }

  # otherwise (since $0 was either 'man' or 'help'),
  #  just assume u wanted the man page
  # note: $section and $page are unquoted so we don't get weird issues w/
  #  empty parameters
  # note 2: we're removing the 0, bc $section is an integer, so defaults to 0
  "${(z)_command[man]}" ${section/0} $page 2> /dev/null && {
    return 0
  } || {  # only show the section error msg if a section was actually given
    (( section )) && { echo "$_section_err" >&2; return 1; }
  }

  # and if there's no man page, check 'tldr'
  "${(z)_command[tldr]}" "$page" 2> /dev/null && return 0

  # finally, if none of the commands had an entry, throw an error
  echo "$_no_match_err" >&2
  return 1
}

# ——————————————————————————————————————————————————————————————————————————— #

man::list_all::man  () { echo "running: man all"                       ; }
man::list_all::help () { man::make_grid "$( run-help -l | tail -n+3 )" ; }
man::list_all::tldr () { man::make_grid 1 "$( command tldr -l )"       ; }

# ——————————————————————————————————————————————————————————————————————————— #

man::make_grid() {
  local -ri 10 COLUMN_SPACING="${1:-2}"; shift

  local -r  cmds_raw="$@"
  # replace any newlines with spaces, and
  #  then split the string into an array at every space
  local -ra cmds_arr=( "${(s: :)cmds_raw//$'\n'/ }" )
  local -ra cmds_arr_sorted=( "${(@o)cmds_arr}" )  # now just sort the array

  local -i 10 max_cmd_len=-1; local cmd
  for cmd in "${cmds_arr_sorted[@]}"; do
    (( ${#cmd} > max_cmd_len )) && max_cmd_len=${#cmd}
  done

  # number of columns = screen_width / ( max_cmd_len + COLUMN_SPACING )
  local -ri 10 cmd_col_width=$(( max_cmd_len + COLUMN_SPACING ))
  local -ri 10 cmd_col_count=$(( COLUMNS / cmd_col_width ))

  local -i 10 i
  for i in {1.."${#cmds_arr_sorted[@]}"}; do
    # print all the commands, with padding equal to $cmd_col_width
    echo -n "${(r:$cmd_col_width:: :)cmds_arr_sorted[i]}"
    # if we reach the end of the column, start a new line
    (( i % cmd_col_count == 0 )) && echo
  done
  # this is here in case there aren't exactly cmd_col_count columns,
  #  in which case, an extra newline will need to be printed
  (( i % cmd_col_count != 0 )) && echo
}
