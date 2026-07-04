import norm/model
import std/times
import user

type
    Posts* = ref object of Model
        title*: string
        content*: string
        likes*: int = 0
        views*: int = 0
        userlink*: User
        create_time*: DateTime