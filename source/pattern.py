from typing import Final
from types_ import json

type _kwarg_type = str | int | bool | json | list[json]

accepted_kwargs: dict[str, list[type]] = {
  # "name"                : [ str        ],
    "contentName"         : [ str        ],
    "match"               : [ str        ],
    "begin"               : [ str        ],
    "end"                 : [ str        ],
    "comment"             : [ str        ],
    "include"             : [ str        ],
    "while_"              : [ str        ],

    "applyEndPatternLast" : [ int, bool  ],
    "disabled"            : [ int, bool  ],

    "captures"            : [      json  ],
    "beginCaptures"       : [      json  ],
    "endCaptures"         : [      json  ],
    "whileCaptures"       : [      json  ],

    "patterns"            : [ list[json] ],
}

class Pattern:
    def __init__(self, name: str, **kwargs: dict[str, _kwarg_type]):
        self.name: Final[str] = name

        for kwarg, value in kwargs.items():
            expected_types: list[_kwarg_type] = accepted_kwargs[kwarg]

            if kwarg not in accepted_kwargs:
                raise ValueError(f"Unknown argument: '{kwarg}'")

            if not isinstance(value, tuple(expected_types)):
                type_names: str = ", or ".join(
                    getattr(t, '__name__', str(t)) for t in expected_types
                )
                raise TypeError(f"'{kwarg}' must be of type {type_names}")

            setattr(self, kwarg, value)

        print(self.__dict__)


def main() -> None:
    Pattern('test1', disabled=True, comment='an comment')
    Pattern('test2', while_="smth", match='smth')


if __name__ == "__main__":
    main()

