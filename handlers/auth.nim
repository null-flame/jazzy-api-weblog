import jazzy except DbValue, dbValue, dbNull
import norm/[sqlite, model]
import std/times
import std/strutils
import ../models/user
import ../config

proc reg*(ctx: Context) {.async.}=
    let data = ctx.validate(%*{"name": "required|min:4",
    "pass": "required|min:7",
    "email": "required|min:4",
    "age": "required|integer"
    })

    var
        name = data["name"].getStr()
        pass = data["pass"].getStr()
        hashedpassword = hashPassword(pass)
        email = data["email"].getStr()
        age = data["age"].getInt()
        create_time = now()
        user = User(name: name, pass: hashedpassword, age: age, create_time: create_time, email: email)
    
    try:
        db.insert(user)
    except:
        ctx.json(%*{"ss": "400", "msg": "This name or email is already in use."})
        return
    let expireTime = getTime().toUnix() + 2592000

    db.select(user, "name = ? AND pass = ? AND email = ?", name, hashedpassword, email)

    let pay = %* {"name": name, "email": email, "age": age, "id": user.id, "exp": expireTime}

    let token = ctx.login(pay, true)
    
    ctx.status(201).json(%*{"ss": "ok", "token": token})

proc loginEmail*(ctx: Context) {.async.}=
    var data = ctx.validate(%*{"email": "required|email", "pass": "required|min:7"})
    try:
        var
            email = data["email"].getStr()
            pass = data["pass"].getStr()
            u = User()
        db.select(u, "email = ?", email)

        if verifyPassword(pass, u.pass):
            var
                email = u.email
                age = u.age
                name = u.name
            let
                exp = getTime().toUnix() + 2592000
                pay = %*{"name": name, "email": email, "age": age, "id": u.id, "exp": exp}
                token = ctx.login(pay, true)
            ctx.json(%*{"ss": 200, "token": token})
        else:
            ctx.json(%*{"ss": "400", "msg": "The email or password is incorrect."})
    except NotFoundError:
        ctx.json(%*{"ss": "400", "msg": "The email or password is incorrect."})
