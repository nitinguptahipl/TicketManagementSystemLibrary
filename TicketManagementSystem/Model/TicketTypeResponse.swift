//
//  TicketTypeResponse.swift
//  FloSenso
//
//  Created by Milan Katiyar on 09/05/23.
//  Copyright © 2023 learning. All rights reserved.
//

import Foundation
class TicketTypeResponse:Decodable{
    var success: Bool?
    var message: String?
    var  data: TicketTypeData?
}

class TicketTypeData : Decodable{
    var INCIDENCE_TYPE:[TicketType]?
    var INCIDENCE_LEVEL:[TicketType]?
}

class TicketType : Decodable{
    var LOOKUP_TYPE_ID: String?
    var LOOKUP_ID: String?
    var LOOKUP_CODE: String?
    var LOOKUP_MEANING: String?
    var VALID: String?
    var IS_DEFAULT: String?
    var DEL: String?
    var IMAGE_PATH: String?
    var INSERTED_BY: String?
    var UPDATED_BY: String?
    var INSERTED_DATE: String?
    var UPDATED_DATE: String?
    var NATURAL_ACCOUNT: String?
}


class SaveResponseComment:Decodable{
    var success: Bool?
    var message: String?
    var data: Incidence_Comments_Data?
}

