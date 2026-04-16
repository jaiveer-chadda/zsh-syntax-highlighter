#!/bin/zsh

ind_col=$'\e[38;2;128;125;237m'
# echo "\e[2m${(r:$COLUMNS::─:)}\e[0m"
# set -x; eval "eval \"\$( fc -ln -1 -1 )\""
line::usage() {
  echo "\e[4mstarting func: $ind_col$0\e[0m"
  line
  return

  local -r     line=$'\e[31mline\e[0m'
  local -r  columns=$'\e[31m$\e[0mCOLUMNS'
  local -r      str=$'\e[33m\'─\'\e[0m'
  local -r      len=$'\e[32mLEN\e[0m'
  local -r     char=$'\e[32mCHAR\e[0m'
  local -r     _n=$'[ \e[32m-n\e[0m ]'
  local -r        e=$'\e[36m=\e[0m'
  local -r    arrow=$'\e[34m ——→ \e[0m'

  local -r p5="${(r:5:: :)}"
  local -r p8="${(r:8:: :)}"

  echo "usage: $line"
  echo '‾‾‾‾‾‾‾‾‾‾‾'
  echo "$line $_n"  $p8       $p8      "$arrow" "len$e$columns" "char$e$str "
  echo "$line $_n ( $len  )"  $p8      "$arrow" "len$e$len$p5"  "char$e$str "
  echo "$line $_n ( $char )"  $p8      "$arrow" "len$e$columns" "char$e$char"
  echo "$line $_n ( $len  ) ( $char )" "$arrow" "len$e$len$p5"  "char$e$char"
  echo "$line $_n ( $char ) ( $len  )" "$arrow" "len$e$len$p5"  "char$e$char"
}

line() {
  echo "\e[4mstarting func: $ind_col$0\e[0m"

  # echo $ZSH_EVAL_CONTEXT
  # echo -n $'\e[A'
  # echo "stack: ${(j:, :)funcstack}"
  local -ri 10 delim=$RANDOM
  local -r stack="${(j:$delim:)funcstack}"

  echo "stack: $stack"

  # line::test
  # [[ "${(j:•:)funcstack}"  ]]
  return

  local -i 2 do_newline=1 do_debug=0
  if [[ "$1" == '-x' ]] { do_debug=1;   shift; }
  if [[ "$1" == '-n' ]] { do_newline=0; shift; }

  if (( do_debug )) echo "\n$0 ${(q)@}" >&2
  
  
  local -i 10 line_len=$COLUMNS
  local line_chr='─'

  if [[ -n "$@" ]] {  # if there are some inputs
    # if $1 is a number
    if [[ "$1" == <-> ]] {
      line_len="$1"              # set $1 as the line length
      line_chr="${2:-$line_chr}" #  and $2 as the line char
    # if $1 isn't a number, but $2 is
    } elif [[ "$2" == <-> ]] {
      line_len="${2:-$line_len}" # set $2 as the line length
      line_chr="${1:-$line_chr}" #  and $1 as the line char
    } else {
      if (( do_debug )) {
        echo $'\e[31m × × × \e[0m'
      } else {
        line::usage >&2
        return 1
      }
    }
  }

  echo -n "${(pr:$line_len::$line_chr:)}"
  if (( do_newline )) echo
}


line_nocheck() { echo "${(r:$1::—:)}"; }


create_title() {
  # Format:
  #  create_title [title] [line_char] [start_len] [min_end_len] [ellipses] [min_letters]
  #   1. title       : str  =  ''
  #   2. line_char   : str  =  '—'
  #   3. start_len   : int  =  3
  #   4. min_end_len : int  =  4
  #   5. ellipses    : str  =  "..."
  #   6. min_letters : int  =  1

  ##title Control Constants (for internal use)

  # the character that indicates that a default value should be used
  local __DFT__='^'
  # the string that will be the sign to draw a line w/o a title
  local __LNE__="%__LNE__%"


  ##title Default Constants (can be overwritten by user)

  # what will show after the truncated title if
  #  there's not enough space to display the whole title
  local __DFT_ellipses="..."
  # the character used to draw the separator lines
  local __DFT_line_char='—'

  # the length of the line before the title
  local __DFT_start_len=3
  # the minimum length that the line after the title should be
  local __DFT_min_end_len=4

  # the minimum number of letters that should be shown before the
  #  function just gives up and draws a line with no title
  local __DFT_min_letters=1


  ##title Input Handling / User Overrides

  local   _title_str=$( [[ $1 == '' || $1 == $__DFT__ ]] && echo $__LNE__           || echo $1 )
  local   _line_char=$( [[ $2 == '' || $2 == $__DFT__ ]] && echo $__DFT_line_char   || echo $2 )
  local   _start_len=$( [[ $3 == '' || $3 == $__DFT__ ]] && echo $__DFT_start_len   || echo $3 )
  local _min_end_len=$( [[ $4 == '' || $4 == $__DFT__ ]] && echo $__DFT_min_end_len || echo $4 )
  local    _ellipses=$( [[ $5 == '' || $5 == $__DFT__ ]] && echo $__DFT_ellipses    || echo $5 )
  local _min_letters=$( [[ $6 == '' || $6 == $__DFT__ ]] && echo $__DFT_min_letters || echo $6 )


  ##title Calculated Constants

  # defining how long the ellipses is 
  local _ellipses_len=${#_ellipses}

  # the starting and ending line strings
  local _start_line=$(get_line $_start_len $_line_char)
  local _min_end_line=$(get_line $_min_end_len $_line_char)

  # this will be compared against the terminal width.
  #  if the term width is smaller than this, then a line with no title will be shown
  local _min_char_count=$(( $_start_len + $_min_end_len + $_ellipses_len + $_min_letters + 2 ))


  ##title Calculated Values

  local _input_length=${#_title_str}
  local _term_width=$(tput cols)

  local _do_draw_title=$(
      [[ $_term_width -lt $_min_char_count || $_title_str == $__LNE__ ]] && echo "false" || echo "true"
  )

  # subtracted 2 to account for the space
  #  after and before the start and end lines, respectively
  local _available_width=$(( $_term_width - ( $_start_len + $_min_end_len + 2 ) ))


  ##title Logic

  [[ $_do_draw_title == "false" ]] && get_line && return

  local _end_line_len=$(
      [[ $_do_draw_title == "false" ]]          && echo $_term_width  && return
      (( $_input_length >= $_available_width )) && echo $_min_end_len && return
      echo $(( $_term_width - ( $_input_length + $_start_len + 2 ) ))
  )

  local _end_line=$(get_line $_end_line_len $_line_char)

  local _trunc_idx=$(
      (( $_input_length > $_available_width )) && echo $(( $_available_width - $_ellipses_len )) || echo -1
  )

  echo -n $_start_line' '${_title_str[0, $_trunc_idx]}
  (( $_trunc_idx != -1 )) && echo -n $_ellipses
  echo ' '$_end_line
}


center_title_nocheck() {
  local _input_title=$1
  local _usable_width=$(( $(tput cols) - ( ${#_input_title} + 2 ) ))
  local _half_width=$(( _usable_width / 2 ))

  get_line_nocheck $_half_width
  echo -n ' '$_input_title' '
  get_line_nocheck $_half_width
  get_line_nocheck $(( _usable_width % 2 ))

}

# spell:ignoreRegExp /\\(?:e|033|x1b)\[[0-9;]+?m\B/g
