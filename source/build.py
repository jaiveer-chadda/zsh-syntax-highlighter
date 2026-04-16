#!/usr/bin/env python3

from typing import Final

from types_ import json


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

    # `top_level_patterns` will be filled in by a future function
    top_level_patterns: list[str]
    output["top_level_patterns"] = [ {"include": f"#{pattern}" } for pattern in top_level_patterns ]

    ...
    return output
