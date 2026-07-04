import norm/model
import post
import user

type
    Like* = ref object of Model
        userlink*: User
        postlink*: Posts
    View* = ref object of Model
        userlink*: User
        postlink*: Posts