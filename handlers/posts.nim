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
            ctx.status(404).json(%*{"msg": "Post not found."})
            return

        try:
            db.select(user, "id = ?", userid)
        except:
            ctx.status(404).json(%*{"msg": "User not found."})
            return
        var view = View(userlink: user, postlink: post)

        try:
            db.insert(view)
            db.exec(sql"UPDATE ""Posts"" SET views = views + 1 WHERE id = ?", post.id)
            post.views += 1
            ctx.json(%*{"ss": "ok", "msg": "You have not viewed this post before.", "data": postJson(post)})
        except:
            ctx.json(%*{"ss": "ok", "msg": "You have already viewed this post.", "data": postJson(post)})
    else: 
        var post = Posts(userlink: User())
        
        try:
            db.select(post, "Posts.id = ?", id)
        except:
            ctx.status(404).json(%*{"msg": "Post not found."})
            return
        
        
        ctx.json(%*{"ss": "ok", "msg": "You are not logged in.", "data": postJson(post)})



proc deletePost*(ctx: Context){.async.}=
    var
        data = ctx.validate(%*{"id": "required|integer"})
        id = data["id"].getInt()
        user_id = ctx.user().get()["id"].getInt()
        post = Posts(userlink: User())
        user = User()
    
    try:
        db.select(post, "Posts.id = ?", id)
    except:
        ctx.status(404).json(%*{"msg": "Post not found."})
        return
    

    if user_id == post.userlink.id:

        db.exec(sql"DELETE FROM ""Like"" WHERE postlink_id = ?", id)

        db.exec(sql"DELETE FROM ""View"" WHERE postlink_id = ?", id)

        db.exec(sql"DELETE FROM ""Posts"" WHERE id = ? AND userlink_id = ?", id, user_id)

        ctx.json(%*{"ss": "ok", "msg": "Your post has been deleted successfully."})

    else: ctx.status(403).json(%*{"ss": "no", "msg": "You are not the owner of this account."})


proc jsonLister(post: Posts): JsonNode=
    return %* {
        "title": post.title,
        "id": post.id,
        "like": post.likes,
        "view": post.views
    }


proc getList*(ctx: Context){.async.}=
    var
        data = ctx.validate(%*{"max": "required|integer", "min": "required|integer"})
    
    let
        max = data["max"].getInt()
        min = data["min"].getInt()
    
    
    if max >= min:

        if max - min <= 10:
            var post_list: seq[Posts]

            try:
                db.select(post_list, "id BETWEEN ? AND ? ORDER BY id DESC", min, max)
            except:
                ctx.status(404).json(%*{"ss": "no", "msg": "Bad request."})
                return
            var json_list = %*[]

            for i in post_list:
                
                json_list.add(jsonLister(i))
            
            ctx.json(%*{"ss": "ok", "data": json_list})



        
        else: ctx.status(400).json(%*{"ss": "no"})


    else: ctx.status(400).json(%*{"ss": "no"})



proc counter*(ctx: Context) {.async.}=

    let count_Post = db.count(Posts, "*", false, "1=1")

    ctx.json(%*{"ss": "ok", "count": count_Post})