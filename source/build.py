#!/usr/bin/env python3

from typing import Final

type json = dict[str, json | str] | list[json]

JSON_SCHEMA: Final[str] = "https://raw.githubusercontent.com/martinring/tmlanguage/master/tmlanguage.json"

LANG:        Final[str] = "zsh"
OUTPUT_FILE: Final[str] = "../syntaxes/zsh.tmLanguage.json"

HEADER_JSON: Final[json] = {
    "$schema"   : JSON_SCHEMA     ,
    "name"      : LANG            ,
    "scopeName" : f"source.{LANG}",
}

def compile():
    output: json = {}

    output |= HEADER_JSON

    # `patterns` will be filled in by a future function
    patterns: list[str]
    output["patterns"] = [ {"include": f"#{pattern}" } for pattern in patterns ]

    ...

    return output
