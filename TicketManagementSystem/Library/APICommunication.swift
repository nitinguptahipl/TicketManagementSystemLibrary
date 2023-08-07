//  ServerCommunication.swift
//  ABBO
//  Created by HIPL-GLOBYLOG on 4/6/20.
//  Copyright © 2020 SamaraTech. All rights reserved.
import UIKit
import Alamofire
import Network

class APICommunication: NSObject {
    class func getDataWithGetWithDataResponseTicketModule(url: String,parameter postParam: Parameters,HeaderParams: [String: String],methodType:HTTPMethod,viewController: UIViewController,success: @escaping(DataResponse<Any>) -> Void,failure: @escaping (NSDictionary) -> Void){
        DataUtil.ShowIndictorView(IndicatoreTitle: "Please wait...")
        
        var param = postParam
        let token =  ticketResp?.TOKEN ?? ""
        if token.count > 0 {
            param["TOKEN"] = token
        }
        param["VERSION_NO"] = appVersion
        //        param["ORG_ID"] = "93"
        //        param["LOCATION_ID"] = "66"
        param["ORG_ID"] = ticketResp?.TICKET_ORG_ID
        param["LOCATION_ID"] = ticketResp?.TICKET_LOCATION_ID
        param["APPLICATION"] = ticketResp?.APPLICATION
        param["DEVICE"] = ticketResp?.DEVICE
        param["SYSTEM_ID"] = ticketResp?.SYSTEM_ID
        param["SIGNIN_TYPE"] = ticketResp?.SIGNIN_TYPE
        param["REQUEST_TYPE"] = ticketResp?.REQUEST_TYPE
        param["APP_DOMAIN"] = ticketResp?.APP_DOMAIN
        
        let urlFinal = (ticketResp?.Base_Url ?? "") + url
        print("urlFinal: \(urlFinal) ")
        print("Post Parameter: \(param) ")
        
        Alamofire.request(urlFinal, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            if let data = response.data{
                // print("******************Json Data Start************************************")
                if let strJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                    print("strJson == ",strJson)
                    
                }
                //  print("******************Json Data End ************************************")
            }
            switch (response.result){
            case .success(_):
                //  print("******************success******************")
                guard let json = response.result.value as? NSDictionary else
                {
                    //  print("Error: \(String(describing: response.result.error))")
                    DataUtil.HideIndictorView()
                    DispatchQueue.main.async {
                        failure(response.result as Any as! NSDictionary )
                    }
                    return
                }
                
                if let httpStatusCode = response.response?.statusCode {
                    if httpStatusCode ==  400 {
                        // let dic = json
                        DataUtil.HideIndictorView()
                        return
                    }
                }
                if let data = response.data{
                    if let strJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                        if url == "getVisit" {
                            DataUtil.saveString(data: strJson as String, key: "getVisit")
                        }
                    }
                }
                DispatchQueue.main.async {
                    success(response)
                }
                DataUtil.HideIndictorView()
            case .failure(_):
                print("******************failure******************")
                DataUtil.alertMessage(response.result.error!.localizedDescription, viewController: viewController)
                print(response.result.error!.localizedDescription)
                var str_error_msg = response.result.error!.localizedDescription
                if (str_error_msg .contains("JSON could not be serialized")) {
                }
                DispatchQueue.main.async {
                    if ((response.result.error) as NSError?)?.code == -1009{
                        if (str_error_msg .contains("JSON could not be serialized")) {
                            DataUtil.alertMessage("Server error...Please try again", viewController: viewController)
                        }
                        else if (str_error_msg .contains(".input data was nil or zero length.")) {
                            DataUtil.alertMessage("Server error...Please try again", viewController: viewController)
                        }
                        else {
                            DataUtil.alertMessage(str_error_msg, viewController: viewController)
                        }
                        DispatchQueue.main.async {
                            let dictFail = NSMutableDictionary()
                            dictFail.setValue(-1009, forKey: "errorCode")
                            failure(dictFail)
                        }
                        return
                    }
                    if (str_error_msg .contains("JSON could not be serialized")) {
                        DataUtil.alertMessage("Server error...Please try again", viewController: viewController)
                        return
                    }
                    DataUtil.alertMessage(str_error_msg, viewController: viewController)
                    return
                }
                DataUtil.HideIndictorView()
            }
        }
    }
    
    class func postPictureAuthorizationHandlerWithVideo(url: String, postParam:Parameters,mediaArr:[(UIImage,NSURL,String,String)],viewController: UIViewController,success:@escaping(DataResponse<Any>) -> Void,failure:@escaping (NSDictionary)->() ) {
        DataUtil.ShowIndictorView(IndicatoreTitle: "Please wait...")
        var params = postParam
        let token =  ticketResp?.TOKEN ?? ""
        if token.count > 0 {
            params["TOKEN"] = token
        }
        params["VERSION_NO"] = appVersion
        //        params["ORG_ID"] = "93"
        //        params["LOCATION_ID"] = "66"
        params["ORG_ID"] = ticketResp?.TICKET_ORG_ID
        params["LOCATION_ID"] = ticketResp?.TICKET_LOCATION_ID
        params["APPLICATION"] = ticketResp?.APPLICATION
        params["DEVICE"] = ticketResp?.DEVICE
        params["SYSTEM_ID"] = ticketResp?.SYSTEM_ID
        params["SIGNIN_TYPE"] = ticketResp?.SIGNIN_TYPE
        params["REQUEST_TYPE"] = ticketResp?.REQUEST_TYPE
        params["APP_DOMAIN"] = ticketResp?.APP_DOMAIN
        
        let urlFinal = (ticketResp?.Base_Url ?? "") + url
        var IncidentImageTypeArray = [String]()
        let modifiedURLString = (ticketResp?.Base_Url ?? "") + url
        if params is Dictionary<String, String> {
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var index = 0
            for item in mediaArr {
                let aa = "INCIDENCE_ASSETS"
                let keyy =   "\(aa)[]"
                print("Key is",keyy)
                var file_name = "assets"
                var mimeType = "image/jpeg"
                var mediaData: Data?
                if item.2 == "image"{
                    print("Image is",item.0)
                    file_name = "upload.jpeg"
                    mimeType = "image/jpeg"
                    mediaData = item.0.jpegData(compressionQuality: 0.6)
                    IncidentImageTypeArray.append("58")
                }
                else {
                    file_name = "upload.mp4"
                    mimeType = "video/mov"
                    do {
                        mediaData = try Data(contentsOf: item.1 as URL, options: Data.ReadingOptions.alwaysMapped)
                        IncidentImageTypeArray.append("59")
                    } catch _ {
                        return
                    }
                }
                if let mData = mediaData {
                    print("File Name is",file_name)
                    multipartFormData.append(mData, withName: keyy, fileName: file_name, mimeType: mimeType)
                }
                index = index + 1
            }
            if IncidentImageTypeArray.count > 0 {
                params["INCIDENCE_IMAGE_TYPE"] = IncidentImageTypeArray
            }
            print("urlFinal: \(urlFinal) ")
            print("Post Parameter: \(params) ")
            print("modifiedURLString: \(modifiedURLString) ")
            for (key, value) in params {
                if value is String{
                    let valueStr = value as! String
                    multipartFormData.append(valueStr.data(using: String.Encoding.utf8)!, withName: key)
                }
                else if value is [String: [String: String]]{
                    let stringsData = NSMutableData()
                    let jsonData = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions())
                    let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
                    if let stringData = jsonString?.data(using: String.Encoding.utf8.rawValue) {
                        stringsData.append(stringData)
                    }
                    multipartFormData.append(stringsData as Data, withName: key)
                }
                else {
                    let stringsData = NSMutableData()
                    let jsonData = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions())
                    let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
                    if let stringData = jsonString?.data(using: String.Encoding.utf8.rawValue) {
                        stringsData.append(stringData)
                    }
                    multipartFormData.append(stringsData as Data, withName: key)
                }
                
                
            }
        }, to:modifiedURLString)
        {
            (result) in
            switch result
            {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                
                upload.responseJSON
                {
                    response in
                    switch response.result{
                    case .success( let value) :
                        success(response)
                        break
                        
                    case .failure( let error) :
                        DataUtil.HideIndictorView()
                        DispatchQueue.main.async {
                            print("response ==",response); DataUtil.alertMessageWithoutAction(response.result.error!.localizedDescription, viewController: viewController)
                            print(response.result.error!.localizedDescription)
                        }
                        break
                        
                    }
                    if let data = response.result.value{
                        print(response.result.value)
                        
                        //    success(response)
                        DataUtil.HideIndictorView()
                    }
                }
                break
                
                
            case .failure(let encodingError):
                DataUtil.HideIndictorView()
                if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                } else {
                    
                }
            }
            
        }
        
        
        
        
    }
    
    class func postPictureAuthorizationHandlerWithVideoTwo(url: String, postParam:Parameters,mediaArr:[(UIImage,NSURL,String,String)],viewController: UIViewController,success:@escaping(DataResponse<Any>) -> Void,failure:@escaping (NSDictionary)->() ) {
        DataUtil.ShowIndictorView(IndicatoreTitle: "Please wait...")
        var params = postParam
        let token =  ticketResp?.TOKEN ?? ""
        if token.count > 0 {
            params["TOKEN"] = token
        }
        params["VERSION_NO"] = appVersion
        //        params["ORG_ID"] = "93"
        //        params["LOCATION_ID"] = "66"
        params["ORG_ID"] = ticketResp?.TICKET_ORG_ID
        params["LOCATION_ID"] = ticketResp?.TICKET_LOCATION_ID
        params["APPLICATION"] = ticketResp?.APPLICATION
        params["DEVICE"] = ticketResp?.DEVICE
        params["SYSTEM_ID"] = ticketResp?.SYSTEM_ID
        params["SIGNIN_TYPE"] = ticketResp?.SIGNIN_TYPE
        params["REQUEST_TYPE"] = ticketResp?.REQUEST_TYPE
        params["APP_DOMAIN"] = ticketResp?.APP_DOMAIN
        
        let urlFinal = (ticketResp?.Base_Url ?? "") + url
        var IncidentImageTypeArray = [String]()
        let modifiedURLString = "https://tessapp.tess360.com/" + url
        if params is Dictionary<String, String> {
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var index = 0
            for item in mediaArr {
                let aa = "INCIDENCE_ASSETS"
                let keyy =   "\(aa)[]"
                print("Key is",keyy)
                var file_name = "assets"
                var mimeType = "image/jpeg"
                var mediaData: Data?
                if item.2 == "image"{
                    print("Image is",item.0)
                    file_name = "upload.jpeg"
                    mimeType = "image/jpeg"
                    mediaData = item.0.jpegData(compressionQuality: 0.6)
                    IncidentImageTypeArray.append("58")
                }
                else {
                    file_name = "upload.mp4"
                    mimeType = "video/mov"
                    do {
                        mediaData = try Data(contentsOf: item.1 as URL, options: Data.ReadingOptions.alwaysMapped)
                        IncidentImageTypeArray.append("59")
                    } catch _ {
                        return
                    }
                }
                if let mData = mediaData {
                    print("File Name is",file_name)
                    multipartFormData.append(mData, withName: keyy, fileName: file_name, mimeType: mimeType)
                }
                index = index + 1
            }
            if IncidentImageTypeArray.count > 0 {
                params["INCIDENCE_IMAGE_TYPE"] = IncidentImageTypeArray
            }
            print("urlFinal: \(urlFinal) ")
            print("Post Parameter: \(params) ")
            print("modifiedURLString: \(modifiedURLString) ")
            for (key, value) in params {
                if value is String{
                    let valueStr = value as! String
                    multipartFormData.append(valueStr.data(using: String.Encoding.utf8)!, withName: key)
                }
                else if value is [String: [String: String]]{
                    let stringsData = NSMutableData()
                    let jsonData = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions())
                    let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
                    if let stringData = jsonString?.data(using: String.Encoding.utf8.rawValue) {
                        stringsData.append(stringData)
                    }
                    multipartFormData.append(stringsData as Data, withName: key)
                }
                else {
                    let stringsData = NSMutableData()
                    let jsonData = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions())
                    let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
                    if let stringData = jsonString?.data(using: String.Encoding.utf8.rawValue) {
                        stringsData.append(stringData)
                    }
                    multipartFormData.append(stringsData as Data, withName: key)
                }
                
                
            }
        }, to:modifiedURLString)
        {
            (result) in
            switch result
            {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                
                upload.responseJSON
                {
                    response in
                    switch response.result{
                    case .success( let value) :
                        success(response)
                        break
                        
                    case .failure( let error) :
                        DataUtil.HideIndictorView()
                        DispatchQueue.main.async {
                            print("response ==",response); DataUtil.alertMessageWithoutAction(response.result.error!.localizedDescription, viewController: viewController)
                            print(response.result.error!.localizedDescription)
                        }
                        break
                        
                    }
                    if let data = response.result.value{
                        print(response.result.value)
                        
                        //    success(response)
                        DataUtil.HideIndictorView()
                    }
                }
                break
                
                
            case .failure(let encodingError):
                DataUtil.HideIndictorView()
                if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                } else {
                    
                }
            }
            
        }
        
        
        
        
    }
}

@available(iOS 12.0, *)
class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .satisfied {
                print("We're connected!")
                // post connected notification
            } else {
                print("No connection.")
                // post disconnected notification
            }
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
