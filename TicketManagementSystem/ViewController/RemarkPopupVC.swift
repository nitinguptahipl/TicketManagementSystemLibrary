//
//  RemarkPopupVC.swift
//  FloSenso
//
//  Created by Milan Katiyar on 07/07/23.
//  Copyright © 2023 learning. All rights reserved.
//

import UIKit
import Alamofire
import Cosmos

class RemarkPopupVC: UIViewController {
    
    @IBOutlet var headerLbl: UILabel!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var textView: UITextView!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var textViewBGView : UIView!
    @IBOutlet var rateView: UIView!
    
    @IBOutlet var ratingStatus: UILabel!
    @IBOutlet var cosomosViews: CosmosView!
    var action : String?
    var incidentData : TicketListData?
    var request_id : String?
    weak var delegate : updatePreviousListDelegate!
    var ttl : String?
    var rating : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textViewBGView.layer.borderColor = UIColor.init(hex: "F8F8F8").cgColor//UIColor.darkGray.cgColor
        self.textViewBGView.layer.borderWidth = 1.0
        self.headerLbl.text = ttl ?? ""
        self.rateView.isHidden = true
        if self.action == "CLOSED"{
            self.submitBtn.setTitle("Next", for: .normal)
            self.submitBtn.setTitle("Next", for: .selected)
            self.submitBtn.setTitle("Next", for: .highlighted)
          
            cosomosViews.rating = 0.0
            cosomosViews.settings.updateOnTouch = true
            cosomosViews.settings.fillMode = .full
            cosomosViews.settings.starSize = 40
            cosomosViews.settings.starMargin = 21
            cosomosViews.settings.filledColor = UIColor(hex: "#0EAB43")
            cosomosViews.settings.emptyBorderColor = UIColor.black
            cosomosViews.settings.emptyColor = UIColor.lightGray
            cosomosViews.settings.filledBorderColor = UIColor.black
            cosomosViews.didFinishTouchingCosmos = { rating in
                self.changeRatingStatus(rating: rating)
            }
        }
        
        setupUI()
    }
    
    func setupUI() {
        headerLbl.font = popUpTitleFont
        headerLbl.textColor = popUpTitleColor
        
        submitBtn.titleLabel?.font = popUpButtonFont
        submitBtn.titleLabel?.textColor = popUpButtonColor
        submitBtn.backgroundColor = popUpButtonBackColor
        
        textView.font = descTextViewFont
        textView.textColor = descTextViewColor
    }
    
    public func changeRatingStatus(rating: Double) {
        let ratingInt = Int(rating)
        self.rating = "\(ratingInt)"
        switch ratingInt {
        case 1:
            self.ratingStatus.text = rating1Text + " " + rating1Unicode
        case 2:
            self.ratingStatus.text = rating2Text +  " " + rating2Unicode
        case 3:
            self.ratingStatus.text = rating3Text +  " " + rating3Unicode
        case 4:
            self.ratingStatus.text = rating4Text +  " " + rating4Unicode
        case 5:
            self.ratingStatus.text = rating5Text +  " " + rating5Unicode
        default:
            self.ratingStatus.text = " "
        }
    }
   
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if self.submitBtn.titleLabel?.text == "Next"{
            if self.validation(){
                self.textViewBGView.isHidden = true
                self.rateView.isHidden = false
                self.submitBtn.setTitle("Submit", for: .normal)
                self.submitBtn.setTitle("Submit", for: .selected)
                self.submitBtn.setTitle("Submit", for: .highlighted)
                self.headerLbl.text = "Please rate our support services"
            }
            return
        }
        if self.validation(){
            self.updateStatus(status: action ?? "", incident_id: request_id ?? "")
        }
    }
    
    func validation() -> Bool{
        if self.textView?.text.count ?? 0 <= 0{
            DataUtil.alertMessageWithoutAction("Please enter remark to proceed", viewController: self)
            return false
        }
        if self.action == "CLOSED" && self.submitBtn.titleLabel?.text == "Submit" && self.rating == nil{
            DataUtil.alertMessageWithoutAction("Please select rating", viewController: self)
            return false
        }
        return true
    }
    
    func updateStatus(status : String, incident_id : String){
            var params:Parameters = ["REQUEST_ID": incident_id,
                                     "ACTION": status,
                                     "REMARK":self.textView.text ?? "","USER_ID":ticketResp?.CUSTOMER_ID ?? ""]
        if let rate = rating{
            params["REMARK"] = (self.textView.text ?? "") + "\nRating:" + rate
        }
            let postParamHeaders = [String: String]()
            APICommunication.getDataWithGetWithDataResponseTicketModule(url: "requestApproverAction", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
                if let cryptoData = successResponseData.data {
                    DataUtil.HideIndictorView()
                    do {
                        let decoder = JSONDecoder()
                        let serviceResponse = try decoder.decode(CheckSuccessResponse.self, from: cryptoData)
                        if serviceResponse.success == true {
                            DataUtil.openAlert(title: " ", message: "SUCCESS"
                                               , viewController: self, alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                                self.dismiss(animated: true,completion: nil)
                                if let dele = self.delegate{
                                    dele.updatePreviousViewData(data: "")
                                }}])
                        }
                        else {
                            if let msg = serviceResponse.message{
                                DataUtil.alertMessageWithoutAction(msg, viewController: self)
                            }
                        }
                    } catch let _ {
                        DataUtil.HideIndictorView()
                    }
                }
            }) { (dictFailure) in
                if let msg = dictFailure.value(forKey: "message"){
                    DataUtil.HideIndictorView()
                    DataUtil.alertMessageWithoutAction(msg as! String, viewController: self)
                }
            }
    }

}
