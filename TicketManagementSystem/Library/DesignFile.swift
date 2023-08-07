//
//  DesignFile.swift
//  TicketManagementSystem
//
//  Created by HIPL on 19/07/23.
//

import Foundation
import UIKit

// Ticket Listing VC
var ticketNoLblFont = UIFont(name: "Poppins-SemiBold", size: 16)
var ticketNoColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var issueTypeLblFont = UIFont(name: "Poppins-SemiBold", size: 13)
var issueTypeLblColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var referenceBtnFont = UIFont(name: "Poppins-SemiBold", size: 14)
var referenceBtnColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var srNoLblFont = UIFont(name: "Poppins-Medium", size: 14)
var srNoLblColor = UIColor.black

var prodNameLblFont = UIFont(name: "Poppins-Medium", size: 14)
var prodNameLblColor = UIColor.black

var warrantyStatusLblFont = UIFont(name: "Poppins-Medium", size: 14)
var warrantyStatusLblColor = UIColor.black

var descLblFont = UIFont(name: "Poppins-SemiBold", size: 13)
var descLblColor = UIColor.darkGray

var reportDateLblFont = UIFont(name: "Poppins-SemiBold", size: 11)
var reportDateLblColor = UIColor.darkGray

var priorityStatusLblFont = UIFont(name: "Poppins-SemiBold", size: 11)
var priorityStatusLblColor = UIColor.darkGray




// Ticket Detail VC
var underWarrantyStatusFont = UIFont(name: "Poppins-SemiBold", size: 11)
var underWarrantyStatusColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var underWarrantyDateFont = UIFont(name: "Poppins-SemiBold", size: 11)
var underWarrantyDateColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var reportedByLblFont = UIFont(name: "Poppins-Medium", size: 13)
var reportedByLblColor = UIColor.darkGray



//Comment in Ticket Detail
var commentorNameFont = UIFont(name: "Poppins-SemiBold", size: 14)
var commentorNameColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var commentDateLblFont = UIFont(name: "Poppins-Regular", size: 13)
var commentDateLblColor = UIColor.darkGray

var commentLblFont = UIFont(name: "Poppins-Regular", size: 13)
var commentLblColor = UIColor.darkGray
 
var buttonTitleFont = UIFont(name: "Poppins-SemiBold", size: 14)
var buttonTitleColor = UIColor.white
var buttonBackgroundColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var commentCountFont = UIFont(name: "Poppins-Medium", size: 13)
var commentCountColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)




//Popup VC
var popUpTitleFont = UIFont(name: "Poppins-SemiBold", size: 15)
var popUpTitleColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var popUpButtonFont =  UIFont(name: "Poppins-SemiBold", size: 15)
var popUpButtonColor = UIColor.white
var popUpButtonBackColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var changePriorityLblFont = UIFont(name: "Poppins-Medium", size: 13)
var changePriorityLblColor  = UIColor.init(hex: "0558AA")

var changePriorityTextFont  = UIFont(name: "Poppins-Medium", size: 13)
var changePriorityTextColor  = UIColor.init(hex: "0558AA")

var descTextViewFont  = UIFont(name: "Poppins-Medium", size: 13)
var descTextViewColor  = UIColor.init(hex: "0558AA")

//Resolution Details
var resolutionHeaderTitleFont = UIFont(name: "Poppins-SemiBold", size: 15)
var resolutionHeaderTitleColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var resolutionTitleFont = UIFont(name: "Poppins-SemiBold", size: 14)
var resolutionTitleColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var resolutionDetailFont = UIFont(name: "Poppins-SemiBold", size: 13)
var resolutionDetailColor = UIColor.darkGray

// Create Ticket VC
var RTserialNoLblFont = UIFont(name: "Poppins-SemiBold", size: 15)
var RTserialNoLblColor = #colorLiteral(red: 0.5609999895, green: 0.5609999895, blue: 0.5609999895, alpha: 1)

var RTaddAttachementLblFont = UIFont(name: "Poppins-SemiBold", size: 15)
var RTaddAttachementLblColor = #colorLiteral(red: 0.5609999895, green: 0.5609999895, blue: 0.5609999895, alpha: 1)

var RTdescLblFont = UIFont(name: "Poppins-SemiBold", size: 15)
var RTdescLblColor = #colorLiteral(red: 0.5609999895, green: 0.5609999895, blue: 0.5609999895, alpha: 1)

var RTtankNameLblFont = UIFont(name: "Poppins-SemiBold", size: 15)
var RTtankNameLblColor = #colorLiteral(red: 0.5609999895, green: 0.5609999895, blue: 0.5609999895, alpha: 1)

var RTwarrantyLblFont = UIFont(name: "Poppins-SemiBold", size: 15)
var RTwarrantyLblColor = #colorLiteral(red: 0.5609999895, green: 0.5609999895, blue: 0.5609999895, alpha: 1)

var RTpriorityLblFont = UIFont(name: "Poppins-SemiBold", size: 15)
var RTpriorityLblColor = #colorLiteral(red: 0.5609999895, green: 0.5609999895, blue: 0.5609999895, alpha: 1)

var RTissueTypeLblFont = UIFont(name: "Poppins-SemiBold", size: 15)
var RTissueTypeLblColor = #colorLiteral(red: 0.5609999895, green: 0.5609999895, blue: 0.5609999895, alpha: 1)

var RTheaderTtlLblFont = UIFont(name: "Poppins-SemiBold", size: 15)
var RTheaderTtlLblColor = #colorLiteral(red: 0.5609999895, green: 0.5609999895, blue: 0.5609999895, alpha: 1)

var RTsubmitBtnFont = UIFont(name: "Poppins-SemiBold", size: 15)
var RTsubmitBtnColor = #colorLiteral(red: 0.5609999895, green: 0.5609999895, blue: 0.5609999895, alpha: 1)

var RTHeaderLblFont = UIFont(name: "Poppins-SemiBold", size: 18)
var RTHeaderLblColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var RTButtonFont = UIFont(name: "Poppins-SemiBold", size: 13)
var RTButtonBtnColor = UIColor.white
var RTButtonBackColor = #colorLiteral(red: 0.00800000038, green: 0.4900000095, blue: 0.2860000134, alpha: 1)

var RTserialNoTFFont = UIFont(name: "Poppins-SemiBold", size: 16)
var RTserialNoTFColor = #colorLiteral(red: 0.4469999969, green: 0.451000005, blue: 0.4629999995, alpha: 1)

var RTaddAttachementTFFont = UIFont(name: "Poppins-SemiBold", size: 16)
var RTaddAttachementTFColor = #colorLiteral(red: 0.4469999969, green: 0.451000005, blue: 0.4629999995, alpha: 1)

var RTdescTFFont = UIFont(name: "Poppins-SemiBold", size: 16)
var RTdescTFColor = #colorLiteral(red: 0.4469999969, green: 0.451000005, blue: 0.4629999995, alpha: 1)

var RTtankNameTFFont = UIFont(name: "Poppins-SemiBold", size: 16)
var RTtankNameTFColor = #colorLiteral(red: 0.4469999969, green: 0.451000005, blue: 0.4629999995, alpha: 1)

var RTwarrantyTFFont = UIFont(name: "Poppins-SemiBold", size: 16)
var RTwarrantyTFColor = #colorLiteral(red: 0.4469999969, green: 0.451000005, blue: 0.4629999995, alpha: 1)

var RTpriorityTFFont = UIFont(name: "Poppins-SemiBold", size: 16)
var RTpriorityTFColor = #colorLiteral(red: 0.4469999969, green: 0.451000005, blue: 0.4629999995, alpha: 1)

var RTissueTypeTFFont = UIFont(name: "Poppins-SemiBold", size: 16)
var RTissueTypeTFColor = #colorLiteral(red: 0.4469999969, green: 0.451000005, blue: 0.4629999995, alpha: 1)
