# Function
<!-- spell:disable -->

<!--
func ()
echo hi
-->

-----------------------------------------------------------------------------------------------------------------------

## Grammar

```zsh
; function [ -T ] word ... [ () ] [ term ]  { list }
; function        word ... [ () ] [ term ] sublist
;                 word ...   ()   [ term ]  { list }
;                 word ...   ()   [ term ] command
```
-----------------------------------------------------------------------------------------------------------------------

## Examples 

### Form 1

```zsh
# —————————————————————————————————— #

function funcname () {
  commands
}

function funcname  ()
{
  commands
}

function funcname()
{ commands }

function funcname() { commands }

function    funcname; { commands }
function -T funcname  { commands }

function -- funcname  { commands }
function -T -- funcname  { commands }

function    fn1 fn2 fn3    { commands }
function    fn1 fn2 fn3()  { commands }
function -T fn1 fn2 fn3 () { commands }

function funcname (); { commands }

# —————————————————————————————————— #
```
-----------------------------------------------------------------------------------------------------------------------

### Form 2

```zsh
# —————————————————————————————————— #

function funcname ()
  command

function funcname(); command

function    funcname; command
function -T funcname
command

function fn1 fn2 fn3; command
function fn1 fn2 fn3(); command

# —————————————————————————————————— #
```
-----------------------------------------------------------------------------------------------------------------------

### Form 3

```zsh
# —————————————————————————————————— #

funcname () {
  commands
}

funcname  ()
{
  commands
}


funcname()
{ commands }

funcname() { commands }
funcname (); { commands }

fn1 fn2 fn3 () { commands }

# —————————————————————————————————— #
```
-----------------------------------------------------------------------------------------------------------------------

### Form 4

```zsh
# —————————————————————————————————— #

funcname ()
  command

funcname(); command

fn1 fn2 fn3(); command
fn1 fn2 fn3  ()
command

# —————————————————————————————————— #
```
-----------------------------------------------------------------------------------------------------------------------
