//
//  TicketListResponse.swift
//  FloSenso
//
//  Created by Milan Katiyar on 10/05/23.
//  Copyright © 2023 learning. All rights reserved.
//

import Foundation
class TicketListResponse:Decodable{
    var success: Bool?
    var message: String?
    var data: AllData?
}

class AllData : Decodable{
    var TICKET_LIST: [TicketListData]?
    var INCIDENCE_TYPE : [TicketType]?
    var INCIDENCE_LEVEL : [TicketType]?
}


class TicketListData : Decodable{
    var ORG_ID : String?
    var REFERENCE_NO : String?
    var LOCATION_ID : String?
    var CUSTOMER_ID : String?
    var CUSTOMER_NAME : String?
    var INCIDENCE_ID : String?
    var CUSTOMER_EMAIL : String?
    var SYSTEM_ID : String?
    var PRODUCT_ID : String?
    var PRODUCT_NAME : String?
    var INCIDENCE_LEVEL : String?
    var STATUS : String?
    var STATUS_MEANING : String?
    var INCIDENCE_LEVEL_MEANING : String?
    var INCIDENCE_TYPE : String?
    var INCIDENCE_TYPE_MEANING : String?
    var COMMENT : String?
    var INCIDENCE_DESCRIPTION : String?
    var UNDER_WARRANTY_CONTRACT : String?
    var WARRANTY_CONTRACT_EXPIRY_DATE : String?
    var PRODUCT_SERIAL_NUMBER : String?
    var INCIDENCE_DATE : String?
    var INCIDENCE_ACTIVITY : [Incidence_Activity]?
    var INCIDENCE_IMAGES : [Incidence_Images_Data]?
    var INCIDENCE_COMMENTS : [Incidence_Comments_Data]?
    var RESOLUTION_DATA : [Incidence_Resolution_data]?
}

class Incidence_Activity : Decodable{
    var LOCATION_ID : String?
    var ORG_ID : String?
    var PROFILE_IMAGE : String?
    var WARRANTY_CONTRACT_EXPIRY_DATE : String?
    var USER_NAME : String?
    var USER_ID : String?
    var SITE_ID : String?
    var INCIDENCE_ID : String?
    var INCIDENCE_ACTIVITY_ID : String?
    var COMMENT_DATE : String?
    var DESCRIPTION : String?
    var IMAGE_ADDED : String?
    var ACTIVITY_TYPE : String?
    var IMAGE_DETAILS : [Image_details]?
}

class Image_details : Decodable{
    var LOCATION_ID : String?
    var ORG_ID : String?
    var USER_ID : String?
    var SITE_ID : String?
    var INCIDENCE_DATE : String?
    var INCIDENCE_IMAGE_TYPE : String?
    var INCIDENCE_ID : String?
    var INCIDENCE_IMAGE_ID : String?
    var COMMENT : String?
    var INCIDENCE_IMAGE : String?
    var INCIDENCE_THUMBNAIL : String?
    var INCIDENCE_GEO_CODE : String?
    var CUSTOMER_ID : String?
}

class Incidence_Images_Data : Decodable{
    var LOCATION_ID : String?
    var ORG_ID : String?
    var USER_ID : String?
    var SITE_ID : String?
    var INCIDENCE_DATE : String?
    var INCIDENCE_IMAGE_TYPE : String?
    var INCIDENCE_ID : String?
    var INCIDENCE_IMAGE_ID : String?
    var COMMENT : String?
    var INCIDENCE_IMAGE : String?
    var INCIDENCE_THUMBNAIL : String?
    var INCIDENCE_GEO_CODE : String?
    var CUSTOMER_ID : String?
    
}

class Incidence_Comments_Data : Decodable{
    var LOCATION_ID : String?
    var ORG_ID : String?
    var PROFILE_IMAGE : String?
    var USER_NAME : String?
    var USER_ID : String?
    var SITE_ID : String?
    var CUSTOMER_ID : String?
    var INCIDENCE_ID: String?
    var INCIDENCE_COMMENT_ID: String?
    var COMMENT_DATE : String?
    var COMMENT : String?
}

class Incidence_Resolution_data : Decodable{
    var RESOLUTION_DETAIL_ID : String?
    var INCIDENCE_ID : String?
    var APP_ID : String?
    var CUSTOMER_ID : String?
    var CUSTOMER_NAME : String?
    var ORG_ID : String?
    var LOCATION_ID : String?
    var USER_ID : String?
    var SITE_ID : String?
    var SYSTEM_ID : String?
    var RESOLUTION_DATE : String?
    var GEO_CODE : String?
    var STATUS : String?
    var STATUS_MEANING : String?
    var RESOLUTION_DESCRIPTION : String?
    var ACTION_PLAN : String?
    var RESOLUTION_IMAGES : [Resolutions_Images_Data]?
    var RESOLUTION_COMMENTS : [Resolutions_Comments_Data]?
}

class Resolutions_Images_Data : Decodable{
    var LOCATION_ID : String?
    var ORG_ID : String?
    var USER_ID : String?
    var SITE_ID : String?
    var RESOLUTION_DATE : String?
    var RESOLUTION_IMAGE_TYPE : String?
    var RESOLUTION_DETAIL_ID : String?
    var RESOLUTION_IMAGE_ID : String?
    var COMMENT : String?
    var RESOLUTION_IMAGE : String?
    var RESOLUTION_THUMBNAIL : String?
    var RESOLUTION_GEO_CODE : String?
    var CUSTOMER_ID : String?
}

class Resolutions_Comments_Data : Decodable{
    var LOCATION_ID : String?
    var ORG_ID : String?
    var USER_ID : String?
    var SITE_ID : String?
    var CUSTOMER_ID : String?
    var RESOLUTION_DETAIL_ID : String?
    var RESOLUTION_COMMENT_ID : String?
    var COMMENT_DATE : String?
    var COMMENT : String?
}


class CheckSuccessResponse:Decodable{
    var success: Bool?
    var message: String?
}
