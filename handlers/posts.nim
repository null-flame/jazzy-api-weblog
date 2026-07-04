import jazzy except DbValue, dbValue, dbNull
import norm/[sqlite, model]
import std/times
import std/strutils
import ../models/[user, post, interactions]
import ../config


proc createPost*(ctx: Context) {.async.}=

    var
        data = ctx.validate(%*{"content": "required", "title": "required|min:5"})
        u = ctx.user
        id = u.get()["id"].getInt
        user = User()
        now = now()
        content = data["content"].getStr()
        title = data["title"].getStr()

    db.select(user, "id = ?", id)
    var post = Posts(userlink: user, create_time: now, content: content, title: title)
    db.insert(post)
    ctx.status(201).json(%*{"ss": "ok"})


proc postJson(post: Posts): JsonNode=
    return %*{"content": post.content, "title": post.title, "like": post.likes, "view": post.views, "create_time": $post.create_time, "owner_user_id": post.userlink.id, "owner_user_name": post.userlink.name}

proc view*(ctx: Context) {.async.}=
    var
        data = ctx.validate(%*{"id": "required|integer"})
        id = data["id"].getInt
        us = ctx.user()
    if us.isSome():
        var 
            userbox = us.get()
            userid = userbox["id"].getInt()
            user = User()    
            post = Posts(userlink: User())

        try:
            db.select(post, "Posts.id = ?", id)
        except:
            ctx.status(404).json(%*{"msg": "notfound, post"})
            return

        try:
            db.select(user, "id = ?", userid)
        except:
            ctx.status(404).json(%*{"msg": "notfound, user"})
            return
        var view = View(userlink: user, postlink: post)

        try:
            db.insert(view)
            db.exec(sql"UPDATE ""Posts"" SET views = views + 1 WHERE id = ?", post.id)
            post.views += 1
            ctx.json(%*{"ss": "ok", "msg": "شما قبلا این پست را ندیده اید!", "data": postJson(post)})
        except:
            ctx.json(%*{"ss": "ok", "msg": "شما قبلا این پست را دیده اید!", "data": postJson(post)})
    else: 
        var post = Posts(userlink: User())
        
        try:
            db.select(post, "Posts.id = ?", id)
        except:
            ctx.status(404).json(%*{"msg": "notfound, post"})
            return
        
        
        ctx.json(%*{"ss": "ok", "msg": "شما وارد حساب کاربری خود نشده اید!", "data": postJson(post)})
