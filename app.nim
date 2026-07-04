import jazzy
import config
import handlers/[posts, auth, actions]

runData()

Route.post("/api/reg", auth.reg)
Route.post("/api/loginEmail", auth.loginEmail)
Route.post("/api/view", posts.view)

Route.groupPath("/api", guard):
    Route.post("/create_post", posts.createPost)
    Route.post("/like", actions.like)
    
    Route.delete("/api/delete", deletePost)


Jazzy.serve(8080)