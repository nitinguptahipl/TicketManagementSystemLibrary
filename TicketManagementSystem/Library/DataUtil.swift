//
//  DataUtil.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 7/23/19.
//  Copyright © 2019 learning. All rights reserved.
//

import UIKit
import MBProgressHUD
import Foundation

class DataUtil: NSObject {
    
    static func setStatusColors(status: String, statusLbl: UILabel,statusView:UIView,statusBTN: UIButton?){
        statusView.layer.borderWidth = 1.5
        statusView.layer.cornerRadius = 13
        var colorTxt = UIColor.init(hex: AppColors.DRAFT)
        if (status == ""){
            statusLbl.textColor = UIColor.init(hex: AppColors.DRAFT)
            colorTxt = UIColor.init(hex: AppColors.DRAFT)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.DRAFT).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.DRAFT).cgColor
        }
        //Open Status
        else if (status == "4"){
            statusLbl.textColor = UIColor.init(hex: AppColors.DRAFT)
            colorTxt = UIColor.init(hex: AppColors.DRAFT)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.DRAFT).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.DRAFT).cgColor
        }
        //Assigned Status
        else if status == "S" {
            colorTxt = UIColor.init(hex: AppColors.ASSIGNED)
            statusLbl.textColor = UIColor.init(hex: AppColors.ASSIGNED)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.ASSIGNED).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.ASSIGNED).cgColor
        }
        //Waiting on Customer
        else if status == "5" {
            colorTxt = UIColor.init(hex: AppColors.WAITING_CUSTOMER)
            statusLbl.textColor = UIColor.init(hex: AppColors.WAITING_CUSTOMER)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.WAITING_CUSTOMER).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.WAITING_CUSTOMER).cgColor
        }
        //Reopen
        else if status == "7" {
            colorTxt = UIColor.init(hex: AppColors.REOPEN)
            statusLbl.textColor = UIColor.init(hex: AppColors.REOPEN)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.REOPEN).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.REOPEN).cgColor
        }
        //Resolved
        else if status == "6" {
            colorTxt = UIColor.init(hex: AppColors.RESOLVED)
            statusLbl.textColor = UIColor.init(hex: AppColors.RESOLVED)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.RESOLVED).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.RESOLVED).cgColor
        }
        //Closed
        else if status == "C" {
            colorTxt = UIColor.init(hex: AppColors.CLOSED)
            statusLbl.textColor = UIColor.init(hex: AppColors.CLOSED)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.CLOSED).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.CLOSED).cgColor
        }
        //Escalated
        else if status == "8" {
            colorTxt = UIColor.init(hex: AppColors.ESCALATED)
            statusLbl.textColor = UIColor.init(hex: AppColors.ESCALATED)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.ESCALATED).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.ESCALATED).cgColor
        }
        //Cancelled
        else if status == "X" {
            colorTxt = UIColor.init(hex: AppColors.CANCELLED)
            statusLbl.textColor = UIColor.init(hex: AppColors.CANCELLED)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.CANCELLED).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.CANCELLED).cgColor
        }
        
        else if status == "9" {
            colorTxt = UIColor.init(hex: AppColors.WAITING_CUSTOMER)
            statusLbl.textColor = UIColor.init(hex: AppColors.WAITING_CUSTOMER)
            statusLbl.layer.borderColor = UIColor.init(hex: AppColors.WAITING_CUSTOMER).cgColor
            statusView.layer.borderColor = UIColor.init(hex: AppColors.WAITING_CUSTOMER).cgColor
        }
       
        if statusBTN != nil {
            statusBTN?.setTitleColor(colorTxt, for: .selected)
            statusBTN?.setTitleColor(colorTxt, for: .normal)
            statusBTN?.setTitleColor(colorTxt, for: .highlighted)
        }
    }

    static let AMADEUS_DATE = "yyyy-MM-dd";
    static let TA_DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";
    static let TA_TIME_FORMAT12AMPM = "hh:mm a";
    
    static func getAgoTime(strDate:String) -> String{
        let receiverDate = DataUtil.convertStringToDate(strDate, reqDateFormat: DataUtil.TA_DATE_FORMAT)
        let timeInterval = Date().timeIntervalSinceNow - receiverDate.timeIntervalSinceNow
        let minTemp  = Int(timeInterval)
        print("minTemp is",timeInterval)
        print("Reciever Date is",receiverDate)
        print("Current Date is",Date())
        print("time Interval is",timeInterval)
        var min = 0
        if (minTemp) < 0 {
            min  = (minTemp) * -1
        }
        else {
            min  = minTemp / 60
            print("min is",min)
        }
        
        if min >= 60 {
            let hour = min/60
            let day = min/(60 * 24)
            print("day for notification==",day)
            if hour < 24 {
                var hr = " hours ago"
                if hour == 1 {
                    hr = " hour ago"
                }
                let strHour = "\(hour)" + hr
                return strHour
            }
            if  day < 7 {
                let dayTest = Int(day)
                return "\(dayTest) day ago"
            }
            else {
                //let dateStr = DateUtil.convertDateToString(date: receiverDate, reqFormat: DateUtil.TA_DATE_FORMAT)
                return strDate
            }
        }
        else {
            if min <= 1 {
                return " just now"
            } else{
                return "\(min)" + " minutes ago"
            }
            
        }
        return ""
    }
    
    static func pushNextScreen(nav:UINavigationController,vc:UIViewController,Identifier:String) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let obj = story.instantiateViewController(withIdentifier: Identifier)
        nav.pushViewController(obj, animated: true)
    }
    
    static func convertDateToString(date : Date, reqFormat : String) -> String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = reqFormat
        let dayString = dateFormater.string(from: date)
        return dayString
    }
    
    static func convertStringToDate(_ dateString : String, reqDateFormat : String)-> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = reqDateFormat
        let dateFormater1 = DateFormatter()
        dateFormater1.dateFormat = self.AMADEUS_DATE
        
        if let dayDate = dateFormater.date(from: dateString){
            return dayDate
        } else if let dayDate = dateFormater1.date(from: dateString){
            return dayDate
        }
        return Date()
    }
    
    static func convertStringToDateReq(_ dateString : String, reqDateFormat : String)-> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = reqDateFormat
        let dateFormater1 = DateFormatter()
        dateFormater1.dateFormat = AMADEUS_DATE11
        
        if let dayDate = dateFormater.date(from: dateString){
            return dayDate
        } else if let dayDate = dateFormater1.date(from: dateString){
            return dayDate
        }
        return Date()
    }
    
    static func lastTwoYearsDate() -> Date {
        var components = DateComponents()
        components.year = -2
        let minDateLast2year = Calendar.current.date(byAdding: components, to: Date())
        return minDateLast2year!
    }
    
    static func last200YearsDate() -> Date {
        var components = DateComponents()
        components.year = -200
        let minDateLast2year = Calendar.current.date(byAdding: components, to: Date())
        return minDateLast2year!
    }
    
    static func next200YearsDate() -> Date {
        var components = DateComponents()
        components.year = 200
        let minDateLast2year = Calendar.current.date(byAdding: components, to: Date())
        return minDateLast2year!
    }
    
    static func previous200YearsDate() -> Date {
        var components = DateComponents()
        components.year = -200
        let minDateLast2year = Calendar.current.date(byAdding: components, to: Date())
        return minDateLast2year!
    }
    
    static func convertDate(stringDate: String, stringDateFormat: String, reqDateFormat: String)->String{
        let dateString = stringDateFormat
        let convertedDate = convertStringToDate(stringDate, reqDateFormat: dateString)
        let convertedStringDate = convertDateToString(date: convertedDate, reqFormat: reqDateFormat)
        return convertedStringDate
    }
    static func getFullName(firstname : String,middlename : String,lastname : String) -> String {
        
        var nameStr = firstname
        
        if firstname.count > 0 && middlename.count > 0 && lastname.count > 0 {
            nameStr = firstname + " " + middlename + " " + lastname
            
        }
        else if firstname.count > 0 && middlename.count < 1 && lastname.count > 0  {
            nameStr = firstname + " " + lastname
        }
        else if firstname.count > 0 && middlename.count > 0 && lastname.count < 1  {
            nameStr = firstname + " " + middlename
        }
        
        
        
        return nameStr
    }
    static func getString(key : String)->String{
        if let stringData = UserDefaults.standard.string(forKey: key) {
            return stringData
        } else{
            return "";
        }
    }
    static func saveString(data : String, key : String){
        UserDefaults.standard.set(data, forKey: key);
    }
    // Screen width.
    class public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    class public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    // TO SHOW LOADER ON SCREEN
    class func ShowIndictorView(IndicatoreTitle: String)  {
        if #available(iOS 13.0, *) {
            let appDel = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            let hud =  MBProgressHUD.showAdded(to: appDel.window ?? UIWindow(), animated: true) as MBProgressHUD
            hud.label.numberOfLines = 0
            hud.label.text = IndicatoreTitle
            hud.contentColor = UIColor.darkGray
            // hud.bezelView.color = UIColor.blue
            //  hud.bezelView.style = .solidColor
        } else {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let hud =  MBProgressHUD.showAdded(to: appDel.window ?? UIWindow(), animated: true) as MBProgressHUD
            hud.label.numberOfLines = 0
            hud.label.text = IndicatoreTitle
            hud.contentColor = UIColor.darkGray
            // hud.bezelView.color = UIColor.blue
            //hud.bezelView.style = .solidColor
        }
    }
    
    // TO HIDE LOADER FROM THE SCREEN
    class func HideIndictorView(){
        if #available(iOS 13.0, *) {
            let appDel = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            MBProgressHUD.hide(for: appDel.window ?? UIWindow(), animated: true)
        } else {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            MBProgressHUD.hide(for: appDel.window ?? UIWindow(), animated: true)
        }
    }
    /*
    class func ShowIndictorView(IndicatoreTitle: String)  {
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let delay = 30 // seconds
        let hud =  MBProgressHUD.showAdded(to: appdel.window!, animated: true) as MBProgressHUD
        hud.label.numberOfLines = 0
        hud.label.text = IndicatoreTitle
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            MBProgressHUD.hide(for: appdel.window!, animated: true)
        }
    }
    
    
    class func ShowIndictorWithoutTime(IndicatoreTitle: String)  {
        let appdel = UIApplication.shared.delegate as! AppDelegate
        
        //let delay = 20 // seconds
        let hud =  MBProgressHUD.showAdded(to: appdel.window!, animated: true) as MBProgressHUD
        hud.label.numberOfLines = 0
        hud.label.text = IndicatoreTitle
        //      //  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
        //            MBProgressHUD.hide(for: appdel.window!, animated: true)
        //        }
        // MBProgressHUD.labelT
    }
    
    class func HideIndictorView()  {
        let appdel = UIApplication.shared.delegate as! AppDelegate
        MBProgressHUD.hide(for: appdel.window!, animated: true)
        //   MBProgressHUD.showAdded(to: self.window, animated: true)
        
        
    }
    */
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    //    class func alertMessage (_ msgString : String,viewController: UIViewController)
    //    {
    //        let alert = UIAlertController(title: "" , message: msgString, preferredStyle: UIAlertController.Style.alert)
    //        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    //        viewController.present(alert, animated: true, completion: nil)
    //    }
    
    class func alertMessageWithoutAction(_ msgString: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: " ", message:msgString, preferredStyle: UIAlertController.Style.alert)
            let image = UIImage(named: "smallLogo")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 130, height: 38)
            let viewLogo = UIView(frame: CGRect(x: 65, y: 0, width: 130, height: 38))
            viewLogo.backgroundColor = .clear
            viewLogo.addSubview(imageView)
            alert.view.addSubview(viewLogo)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in            }))
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = viewController.view
                    popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.maxY-60, width: 0, height: 0)
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
                }
            }
            viewController.present(alert, animated: true, completion: nil)
        }
        
    }
    
    class func alertMessage(_ msgString: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: " ", message:msgString, preferredStyle: UIAlertController.Style.alert)
            let image = UIImage(named: "smallLogo")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 130, height: 38)
            let viewLogo = UIView(frame: CGRect(x: 65, y: 0, width: 130, height: 38))
            viewLogo.backgroundColor = .clear
            viewLogo.addSubview(imageView)
            alert.view.addSubview(viewLogo)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction!) in
                if msgString == "No devices are configured. Please setup device. (ignore if already done)." {
                    viewController.tabBarController?.selectedIndex = 3
                }
                else {
                    viewController.dismiss(animated: true)
                }
            }))
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = viewController.view
                    popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.maxY-60, width: 0, height: 0)
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
                }
            }
            viewController.present(alert, animated: true, completion: nil)
        }
        
    }
    
    class func openAlert(title: String, message: String, viewController: UIViewController, alertStyle:UIAlertController.Style, actionTitles:[String], actionStyles:[UIAlertAction.Style], actions: [((UIAlertAction) -> Void)]){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
            let image = UIImage(named: "smallLogo")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 130, height: 38)
            let viewLogo = UIView(frame: CGRect(x: 65, y: 0, width: 130, height: 38))
            viewLogo.backgroundColor = .clear
            if alertStyle != .alert{
                
            } else {
                viewLogo.addSubview(imageView)
                alertController.view.addSubview(viewLogo)
            }
            for(index, indexTitle) in actionTitles.enumerated(){
                let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
                alertController.addAction(action)
            }
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
                if let popoverController = alertController.popoverPresentationController {
                    popoverController.sourceView = viewController.view
                    popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.maxY-60, width: 0, height: 0)
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
                }
            }
            
            viewController.present(alertController, animated: true)
        }
    }
    
    class func alertMessage2(_ msgString: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: " ", message:msgString, preferredStyle: UIAlertController.Style.alert)
            let image = UIImage(named: "smallLogo")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 130, height: 38)
            let viewLogo = UIView(frame: CGRect(x: 65, y: 0, width: 130, height: 38))
            viewLogo.backgroundColor = .clear
            viewLogo.addSubview(imageView)
            alert.view.addSubview(viewLogo)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = viewController.view
                    popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.maxY-60, width: 0, height: 0)
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
                }
            }
            viewController.present(alert, animated: true, completion: nil)
        }
        
    }
        
    static func checkAppVersionLatest(controller: UIViewController, version : String){
        DispatchQueue.main.async {
            alertController(controller: controller, title: "New Update", message: "New version is available. Please update to version \(version) now.")
        }
    }
    
    static func alertController(controller:UIViewController,title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "UPDATE", style: .default, handler: { (action: UIAlertAction!) in
            // Need to Add App Id When app published
            if let url = URL(string: "https://apps.apple.com/in/app/flosenso/id6446999359"),
               UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = controller.view
                popoverController.sourceRect = CGRect(x: controller.view.bounds.midX, y: controller.view.bounds.maxY-60, width: 0, height: 0)
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
            }
        }
        DispatchQueue.main.async {
            controller.present(alert, animated: true)
        }
    }
    
    static func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }
    
    static func showToast(message : String, font: UIFont, vc: UIViewController) {

        let toastLabel = UILabel(frame: CGRect(x: vc.view.frame.size.width/2 - 75, y: vc.view.frame.size.height-150, width: 150, height: 35))
        toastLabel.backgroundColor = #colorLiteral(red: 0.9610000253, green: 0.9610000253, blue: 0.9610000253, alpha: 1)
        toastLabel.textColor = #colorLiteral(red: 0.4469999969, green: 0.451000005, blue: 0.4629999995, alpha: 1)
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 17.5;
        toastLabel.clipsToBounds  =  true
        vc.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.2, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

class BorderView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    func configure(){
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 18
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    
}

public class AppWindow:NSObject {
    public static let shared = AppWindow()
    
    public var window: UIWindow?
    public func setWidow(windo :UIWindow) {
        self.window = windo
    }
    //Initializer access level change now
    private override init(){}
    
}
extension String {
    func validateEmail() -> Bool {
        let emailRegex : String =
        "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailTest.evaluate(with:self)
    }
}
