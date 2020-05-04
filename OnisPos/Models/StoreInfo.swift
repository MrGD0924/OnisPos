//
//  StoreInfo.swift
//  OnisPos
//
//  Created by MG on 4/18/20.
//  Copyright © 2020 MG. All rights reserved.
//

struct StoreInfo {
    var storename: String?
    var regnum: String?
    var dealernum: String?
    var isvatpayer: Int?
    var distcode: String?
    var vatpercent: Int?
    var phonenum: String?
    var citytaxpercent: Int?
    var classcode: String?
    var email: String?
    var address: String?
    var ownername: String?
    var storeid: Int?
    
    init(_ storename: String?,_ regnum: String?,_ dealernum: String?,_ isvatpayer: Int?,_ distcode: String?,_ vatpercent: Int?,_ phonenum: String?,_ citytaxpercent: Int?,_ classcode: String?,_ email: String?,_ address: String?,_ ownername: String?,_ storeid: Int?){
        
        self.storename = storename
        self.regnum = regnum
        self.dealernum = dealernum
        self.isvatpayer = isvatpayer
        self.distcode = distcode
        self.vatpercent = vatpercent
        self.phonenum = phonenum
        self.citytaxpercent = citytaxpercent
        self.classcode = classcode
        self.email = email
        self.address = address
        self.ownername = ownername
        self.storeid = storeid
        
    }
}
