import norm/model
import std/times

type
    User* = ref object of Model
        name*: string
        pass*: string
        email*: string
        age*: int
        create_time*: DateTime