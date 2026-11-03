# If
<!-- spell:disable -->

> Note that a `list` needs a terminator, while a `sublist` doesn't.
> - Terminators are usually `;` or `\n`

-----------------------------------------------------------------------------------------------------------------------

## Grammar

```zsh
if list then list   [ elif list then list   ] ... [ else   list   ] fi
if list    { list } [ elif list    { list } ] ... [ else { list } ]
if list   sublist

```
-----------------------------------------------------------------------------------------------------------------------

## Examples

### Form 1

```zsh
# —————————————————————————————————— #

if [[ condition ]]
then
  commands
fi

# —————————————————————————————————— #

if [[ condition ]]; then commands; fi

# —————————————————————————————————— #

if [[ condition ]]
then
  commands
elif (( condition )); then
  commands
else
  commands
fi

# —————————————————————————————————— #
```

-----------------------------------------------------------------------------------------------------------------------

### Form 2

```zsh
# —————————————————————————————————— #

if [[ condition ]] {
  commands
}

# —————————————————————————————————— #

if [[ condition ]] { commands }

# —————————————————————————————————— #

if [[ condition ]] {
  commands
} elif (( condition )) {
  commands
} else {
  commands
}

# —————————————————————————————————— #
```

-----------------------------------------------------------------------------------------------------------------------

### Form 3

```zsh
# —————————————————————————————————— #

if [[ condition ]] commands

# —————————————————————————————————— #
```

-----------------------------------------------------------------------------------------------------------------------

### Extra

```zsh
if { commands }  then commands; fi  # valid   form 1
if { commands }; then commands; fi  # valid   form 1
if { commands }     { commands }    # valid   form 2
if { commands };    { commands }    # invalid form 3
if { commands }       commands      # valid   form 3

```

-----------------------------------------------------------------------------------------------------------------------
