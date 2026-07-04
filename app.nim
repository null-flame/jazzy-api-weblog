import jazzy
import config
import handlers/[posts, auth, actions]

runData()

type
    methods = enum
        GET, POST, PUT, DELETE

proc rate(m: methods, int1, int2: int, url: string, handler: proc(ctx: Context) {.async.}) {.async.} =
    if m == methods.GET:
        Route.groupPath("/", rateLimit(int1, int2)):
            Route.get(url, handler)
    elif m == methods.POST:
        Route.groupPath("/", rateLimit(int1, int2)):
            Route.post(url, handler)
    elif m == methods.PUT:
        Route.groupPath("/", rateLimit(int1, int2)):
            Route.put(url, handler)
    elif m == methods.DELETE:
        Route.groupPath("/", rateLimit(int1, int2)):
            Route.delete(url, handler)


discard rate(methods.POST, 2, 60, "/api/reg", reg)


discard rate(methods.POST, 3, 60, "/api/loginEmail", loginEmail)


discard rate(methods.POST, 10, 60, "/api/view", view)


discard rate(methods.POST, 10, 60, "/api/get_post", getList)


Route.groupPath("/api", guard):
    
    discard rate(methods.POST, 5, 60, "/create_post", createPost)

    discard rate(methods.POST, 10, 60, "/like", like)

    discard rate(methods.DELETE, 3, 60, "/delete", deletePost)


Jazzy.serve(8080)