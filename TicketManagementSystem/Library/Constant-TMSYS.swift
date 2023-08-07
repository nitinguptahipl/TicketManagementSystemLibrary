//
//  Constant-Ebots.swift
//  EnergyBots
//
//  Created by HIPL-GLOBYLOG on 12/15/20.
//  Copyright © 2020 learning. All rights reserved.
//

import Foundation
import UIKit
// Profuction URL
//var baseUrl_tmsys = "https://tessapp.tess360.com/"
//Test URL
//var baseUrl_hrss = "https://www.energy-bots.com/ebots-api-new/index.php/wlc_test/Mobile_wlc_new/"
var ticketResp:TicketData?
var macId = [String]()
var loginType = "P"
var deviceTokenG = ""
var loginTokenG = ""
var userRole = ""
var userId = ""
var appVersion = ""
var language = ""

let greenColor = "#009846"

let AMADEUS_DATE = "yyyy-MM-dd";
let AMADEUS_DATE11 = "dd-MM-yyyy";

var rating1Text = "Not Satisfied"
var rating1Unicode = "\u{1F621}"

var rating2Text = "Okay"
var rating2Unicode = "\u{1F641}"

var rating3Text = "Average"
var rating3Unicode = "\u{1F610}"

var rating4Text = "Good"
var rating4Unicode = "\u{1F603}"

var rating5Text = "Very good"
var rating5Unicode = "\u{1F601}"

struct AppColors{
    
   static let cellBackgroundDraft = "#E0F9F0"//Draft cell color
    static let LeaveCancelled = "#FF9C00" // X status
    static let LeaveCancellationInitiated = "#E6C300" // Q status
    static let LeaveCancelledFuture = "#008000" // H status
    
    
    static let APPROVED = "#0DAC43" //Approved
    static let PENDING = "#666666" //Pending for approval
    static let WITHDRAW = "#ffffdc7e"
    static let REJECT = "#ff3030" //Rejected
    static let COMPLETED = "#009846"//Completed
    static let DRAFT = "#005AA4" //Draft
    static let BOOKED = "#ff9c00"
    static let BOOKED_A = "#808000" //Booked
    static let PARTIALLY_BOOKED = "#009a1a" //009a1a //Partially booked
    static let BOOKING_AWAITED = "#ff9c00"
    static let PURPLE = "#800080" //Awaiting booking
    static let DRAFT_DARK = "#0558AA"
    static let OLIVE = "#808000"
    static let PENDING_AUDIT = "#008000" //Pending Audit
    static let AUDITED = "#005A00" //Audited
    static let CANCEL_INITIATED = "#E6C300" //Cancellation Initiated
    static let ERROR_ENCOUNTERED = "FF5733"//Error encountered
    static let UNDER_REVIEW = "23FFA7"//UNDER REVIEW J
    static let VERIFIED = "0B97C1"//VERIFIED V
    static let CLARIFICATION = "A40000"//CLARIFICATION N
    
    static let TRAVEL_CALENDAR = "#0558AA"
    static let ANNOUNCE_CALENDAR = "FFAE00"
    static let TASK_CALENDAR = "#97C14C"
    
    static let LEAVE_CALENDAR = "#CDE5DF"
    static let HOLIDAY_CALENDAR  = "#CF0001"
    
    static let WORKED = "#2ECC71"// WORKED HOURS
    static let TOTAL = "#F1C40F"//EXPECTED HOURS
    static let EXTRA = "#E74C3C" //EXTRA HOURS
    static let LESS = "#3498DB" //LESS HOURS
    
    static let ENTITLED = "#C12552" //ENTITLED LEAVE
    static let AVAILED = "#FF6600" //AVAILED LEAVE
    static let BALANCE = "#F5C700" //BALANCE LEAVE
    static let AWAITING = "#6A961F" //AWAITING LEAVE
    
     static let CELLBACKGROUND = "#97C14C" //AWAITING LEAVE

    static let OPEN = "#005AA4"
    static let ASSIGNED = "#666666"
    static let WAITING_CUSTOMER = "#e6c300"
    static let REOPEN = "#97C14C"
    static let RESOLVED = "#0DAC43"
    static let CLOSED = "#009846"
    static let ESCALATED = "#d1323f"
    static let CANCELLED = "#ff9c00"
}
