import jazzy except DbValue, dbValue, dbNull
import norm/[sqlite, model]
import std/times
import std/strutils
import models/[post, user, interactions]


var db* = open("test.db", "", "", "")
proc runData*()=

    


    db.createTables(User())
    db.createTables(Posts(userlink: User()))
    db.createTables(Like(userlink: User(), postlink: Posts(userlink: User())))
    db.createTables(View(userlink: User(), postlink: Posts(userlink: User())))