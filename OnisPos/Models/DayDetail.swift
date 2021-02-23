//
//  DayDetail.swift
//  OnisPos
//
//  Created by MG on 4/27/20.
//  Copyright © 2020 MG. All rights reserved.
//

struct DayDetail{
    var slsnum: String?
    var slstime: String?
    var amount: Int?
    var custemail: String?
    
    init(_ slsnum: String?,_ slstime: String?,_ amount: Int?,_ custemail: String?){
        self.slsnum = slsnum
        self.slstime = slstime
        self.amount = amount
        self.custemail = custemail
    }
}
