import jazzy
import handlers/auth
import handlers/posts 
import handlers/actions

proc createRoute*()=
    
    Route.post("/api/reg", auth.reg)
    Route.post("/api/loginEmail", auth.loginEmail)
    Route.post("/api/view", posts.view)


    Route.groupPath("/api", guard):
        Route.post("/create_post", posts.createPost)
        Route.post("/like", actions.like)
