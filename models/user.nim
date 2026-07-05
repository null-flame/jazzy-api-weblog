import norm/model
import std/times
import norm/pragmas


type
    User* = ref object of Model
        name*  {.unique.}: string
        pass*: string
        email* {.unique.}: string
        age*: int
        create_time*: DateTime