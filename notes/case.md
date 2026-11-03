# Case

-----------------------------------------------------------------------------------------------------------------------

## Grammar

```zsh
case word in [ [(] pattern [ | pattern ] ... ) list (;;|;&|;\|) ] ... esac
case word  { [ [(] pattern [ | pattern ] ... ) list (;;|;&|;\|) ] ... }
```

-----------------------------------------------------------------------------------------------------------------------

## Examples

### Form 1

```zsh
# —————————————————————————————————— #

case test in
  pattern ) commands ;;
  pattern ) commands ;&
  pattern ) commands ;|
esac

# —————————————————————————————————— #

case test in
  pattern | pattern ) commands ;;
  pattern | pattern ) commands ;&
  pattern | pattern ) commands ;|
esac

# —————————————————————————————————— #

case test in
  ( pattern ) commands ;;
  ( pattern ) commands ;&
  ( pattern ) commands ;|
esac

# —————————————————————————————————— #
```

-----------------------------------------------------------------------------------------------------------------------


### Form 2

```zsh
# —————————————————————————————————— #

case test {
  pattern ) commands ;;
  pattern ) commands ;&
  pattern ) commands ;|
}

# —————————————————————————————————— #

case test {
  pattern | pattern ) commands ;;
  pattern | pattern ) commands ;&
  pattern | pattern ) commands ;|
}

# —————————————————————————————————— #

case test {
  ( pattern ) commands ;;
  ( pattern ) commands ;&
  ( pattern ) commands ;|
}

# —————————————————————————————————— #
```

-----------------------------------------------------------------------------------------------------------------------
