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
        ctx.status(404).json(%*{"msg": "notfound, post"})
        return
    try:
        db.select(user, "id = ?", userid)
    except:
        ctx.status(404).json(%*{"msg": "notfound, user"})
        return
    let count = db.count(Like, "*", false, "postlink = ? AND userlink = ?", post, user)

    if count == 0:
        var liked = Like(userlink: user, postlink: post)
        db.insert(liked)

        post.likes += 1
        db.update(post)

        ctx.json(%*{"ss": "ok", "like": post.likes})
    elif count == 1:
        ctx.status(400).json(%*{"msg": "شما قبلا لایک کرده اید!"})
