# Loops, Conditionals, & Reserved Words
<!-- spell:disable -->

-----------------------------------------------------------------------------------------------------------------------

## Definitions

### Simple Command

A **simple command** is a sequence of optional parameter assignments followed by blank-separated words, with optional
  redirections interspersed.

The first *word* is the command to be executed, and the remaining words, if any, are arguments to the command.
If a command name is given, the parameter assignments modify the environment of the command when it is executed.
The value of a simple command is its exit status, or 128 plus the signal number if terminated by a signal.

For example,
```zsh
echo foo
```
is a simple command with arguments.

-----------------------------------------------------------------------------------

### Pipeline

A **pipeline** is either a simple command, or a sequence of two or more simple commands where each command is separated
  from the next by `|` or `|&`.
Where commands are separated by `|`, the standard output of the first command is
  connected to the standard input of the next.

`|&` is shorthand for `2>&1 |`, which connects both the standard output and the standard error of the command to the
  standard input of the next.

The value of a *pipeline* is the value of the last command, unless the *pipeline* is preceded by `!` in which case the
  value is the logical inverse of the value of the last command.

For example,
```zsh
echo foo | sed 's/foo/bar/'
```
is a *pipeline*, where the output (`foo` plus a newline) of the first command is passed to the input of the second.

#### `coproc`
If a *pipeline* is preceded by **`coproc`**, it is executed as a *coprocess*; a two-way pipe is established between it
  and the parent shell.

The shell can read from or write to the *coprocess* by means of the `>&p` and `<&p` redirection operators or with
  `print -p` and `read -p`.

A *pipeline* cannot be preceded by both `coproc` and `!`.

If job control is active, the *coprocess* can be treated in other than input and output as an ordinary background job.

-----------------------------------------------------------------------------------

### Sublist

A **sublist** is either a single *pipeline*, or a sequence of two or more *pipeline*s separated by `&&` or `||`.

If two *pipeline*s are separated by `&&`, the second is executed only if the first succeeds (returns a `0` status).
If two *pipeline*s are separated by `||`, the second is executed only if the first fails (returns a non-`0` status).
Both operators have equal precedence and are left associative.

The value of the *sublist* is the value of the last *pipeline* executed.

For example,
```zsh
dmesg | grep panic && print yes
```
is a *sublist* consisting of two *pipeline*s,
  the second, just a simple command, which will be executed if and only if the `grep` command returns a `0` status.
If it does not, the value of the *sublist* is that return status, else it is the status returned by the `print`.

-----------------------------------------------------------------------------------

### List

A **list** is a sequence of zero or more *sublists*,
  in which each *sublist* is terminated by `;`, `&`, `&|`, `&!`, or a newline.

This terminator may optionally be omitted from the last *sublist* in the *list*
  when the *list* appears as a complex command inside `(...)` or `{...}`.

When a *sublist* is terminated by `;` or newline, the shell waits for it to finish before executing the next *sublist*.

If a *sublist* is terminated by a `&`, `&|`, or `&!`, the shell executes the last *pipeline* in it in the background,
  and does not wait for it to finish (note the difference from other shells which execute the whole *sublist*
  in the background).

A backgrounded *pipeline* returns a status of `0`.

More generally, a *list* can be seen as a set of any shell commands whatsoever, including the complex commands below;
  this is implied wherever the word `list` appears in later descriptions.

For example, the commands in a shell function form a special sort of *list*.

-----------------------------------------------------------------------------------------------------------------------

## Loops & Conditionals

### Misc
`!`
`{` `}`

### if elif else
`if`      <!-- if, then, elif, else, fi -->
`then`
`elif`
`else`
`fi`

### for while until foreach
`for`     <!-- for, in, do, done -->
`in`      <!-- [not technically reserved, but it fits] -->
`while`   <!-- while, do, done -->
`until`   <!-- until, do, done -->
`do`
`done`

`foreach` <!-- foreach, end -->
`end`

### case
`case`    <!-- case, in, esac -->
`esac`

### repeat select
`repeat`  <!-- repeat, do, done -->
`select`  <!-- select, in, do, done -->

### always
`always`

-----------------------------------------------------------------------------------------------------------------------

## Forms of Loops & Conditionals

> Note that a `list` needs a terminator, while a `sublist` doesn't.
> - Terminators are usually `;` or `\n`

--------------------------------------------------

### if elif else

```zsh
if list then list   [ elif list then list   ] ... [ else   list   ] fi
if list    { list } [ elif list    { list } ] ... [ else { list } ]
if list   sublist
```
--------------------------------------------------

### for / foreach

```zsh
for     name ... [ in word ... ] term do list done
for     name ... [ in word ... ] term sublist

for     name ... (    word ... )      sublist
foreach name ... (    word ... )         list end

for (( [expr1] ; [expr2] ; [expr3] )) do list done
for (( [expr1] ; [expr2] ; [expr3] )) sublist
```
--------------------------------------------------

### select

```zsh
select name [ in word ... term ] do list done
select name [ in word ... term ] sublist
```
--------------------------------------------------

### while / until

```zsh
while list do list done
until list do list done

while list  { list }
until list  { list }
```
--------------------------------------------------

### case

```zsh
case word in [ [(] pattern [ | pattern ] ... ) list (;;|;&|;\|) ] ... esac
case word  { [ [(] pattern [ | pattern ] ... ) list (;;|;&|;\|) ] ... }
```
--------------------------------------------------

### repeat

```zsh
repeat word do list done
repeat word sublist
```
--------------------------------------------------

### always

```zsh
{ list } always { list }
```

-----------------------------------------------------------------------------------------------------------------------
