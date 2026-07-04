import jazzy except DbValue, dbValue, dbNull
import norm/[sqlite, model]
import std/times
import std/strutils
import ../models/[post, user, interactions]
import ../config



proc like*(ctx: Context) {.async.}=
    var
        u = ctx.user
        userid = u.get()["id"].getint()
        data = ctx.validate(%*{"id": "required|integer"})
        id = data["id"].getInt
        post = Posts(userlink: User())
        user = User()
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
    var like = Like(userlink: user, postlink: post)

    try:
        db.insert(like)

        db.exec(sql"UPDATE ""Posts"" SET likes = likes + 1 WHERE id = ?", post.id)

        post.likes += 1

        ctx.json(%*{"ss": "ok", "like": post.likes})

    except:
        ctx.status(400).json(%*{"msg": "You have already liked this post."})