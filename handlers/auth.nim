import jazzy except DbValue, dbValue, dbNull
import norm/[sqlite, model]
import std/times
import std/strutils
import ../models/user
import ../config
import ../services/auth_service


proc reg*(ctx: Context) {.async.}=
    let data = ctx.validate(%*{"name": "required|min:4",
    "pass": "required|min:7",
    "email": "required|min:4",
    "age": "required|integer"
    })
    
    try:
        setUserInDataBase(data)
    except:
        ctx.status(400).json(%*{"ss": "400", "msg": "This name or email is already in use."})
        return

    let token = ctx.createToken(data)
    
    ctx.status(201).json(%*{"ss": "ok", "token": token})

proc loginEmail*(ctx: Context) {.async.}=
    var data = ctx.validate(%*{"email": "required|email", "pass": "required|min:7"})

    if checkTrue(data):

        let token = ctx.createToken(data)
        
        ctx.json(%*{"ss": "ok", "token": token})

    else:
        ctx.json(%*{"ss": "400", "msg": "The email or password is incorrect."})
