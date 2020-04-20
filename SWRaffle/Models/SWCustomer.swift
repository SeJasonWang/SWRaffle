//
//  SWCustomer.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/16.
//  Copyright © 2020 UTAS. All rights reserved.
//

import Foundation

public struct SWCustomer {
    var name:String
    // Key: Raffle ID
    // Value: Ticket Number
    var tickets:Dictionary<Int32, Int32>
}

