//
//  DayReport.swift
//  OnisPos
//
//  Created by MG on 4/27/20.
//  Copyright © 2020 MG. All rights reserved.
//

struct DayReport {
    var name: Int?
    var amount: Int?
    var count: Int?
    var expand: Bool?
    var listData: [DayDetail]?
    
    init(_ name: Int?,_ amount: Int?,_ count: Int?,_ expand: Bool?){
        self.name = name
        self.amount = amount
        self.count = count
        self.expand = expand
    }
}
