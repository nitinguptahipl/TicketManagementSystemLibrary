//
//  LoginResponse.swift
//  EnergyBots
//
//  Created by HIPL-GLOBYLOG on 12/18/20.
//  Copyright © 2020 learning. All rights reserved.
//

import Foundation

class TicketData : Decodable{
    var TOKEN: String?
    var TICKET_ORG_ID: String?
    var TICKET_LOCATION_ID: String?
    var CUSTOMER_ID: String?
    var CUSTOMER_NAME: String?
    var CUSTOMER_EMAIL: String?
    var CUSTOMER_PHONE: String?
    var APPLICATION: String?
    var DEVICE: String?
    var SIGNIN_TYPE: String?
    var REQUEST_TYPE: String?
    var APP_DOMAIN: String?
    var SYSTEM_ID: String?
    var Base_Url: String?
}

class ReportResponse:Decodable{
    var success: Bool?
    var message: String?
}
