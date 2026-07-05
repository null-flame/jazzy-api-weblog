import jazzy except DbValue, dbValue, dbNull
import norm/[sqlite, model]
import std/times
import std/strutils
import ../models/user
import ../config





proc createToken*(ctx: Context, data: JsonNode): string=
    
    var user = User(email: data["email"].getStr())

    db.select(user, "email = ?", user.email)

    let exp = getTime().toUnix() + 2592000

    let pay = %* {"name": user.name, "email": user.email, "age": user.age, "id": user.id, "exp": exp}

    let token = ctx.login(pay, true)
    
    return token



proc setUserInDataBase*(data: JsonNode)=
    
    let
        name = data["name"].getStr
        email = data["email"].getStr
        pass = data["pass"].getStr.hashPassword()
        age = data["age"].getInt
        create_time = now()

    var user = User(name: name, email: email, pass: pass, age: age, create_time: create_time)

    db.insert(user)


proc checkTrue*(data: JsonNode): bool=

    let
        email = data["email"].getStr()
        pass = data["pass"].getStr()
    
    let count = db.count(User, "*", false, "email = ?", email)

    if count == 1:
        var user = User()
        db.select(user, "email = ?", email)
        let passD = user.pass
        return verifyPassword(passD, pass)
    else: return false




