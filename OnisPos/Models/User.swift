//
//  User.swift
//  OnisPos
//
//  Created by MG on 5/1/20.
//  Copyright © 2020 MG. All rights reserved.
//

struct User {
    var userid: Int?
    var username: String?
    var phonenum: String?
    var check: Bool?
    
    init(_ userid: Int?, _ username: String?,_ phonenum: String?, _ check : Bool?){
        self.userid = userid
        self.username = username
        self.phonenum = phonenum
        self.check = check
    }
}
