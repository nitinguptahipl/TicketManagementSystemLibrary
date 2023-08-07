//
//  TicketDetailsVC.swift
//  FloSenso
//
//  Created by Milan Katiyar on 09/05/23.
//  Copyright © 2023 learning. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import AVKit
import DropDown

protocol CollectionViewCellDelegate2: AnyObject {
    func collectionView2(collectionviewcell: MediaImageListCollecCell3?, index: Int, didTappedInTableViewCell: CommentListCell, data : Image_details)
}

class TicketDetailsVC: BaseVC {
    var incidenceId : String?
    var incidentData : TicketListData?
    var incidenceImages = [Incidence_Images_Data]()
    var incidenceComments = [Incidence_Comments_Data]()
    var resolutionData = [Incidence_Resolution_data]()
    
    var incidenceActivity : [Incidence_Activity]?
    var incidenceActivityIncidenceImages : [Image_details]?
    var incidenceCommentsData : [Incidence_Activity]?
    var incidenceResolutionData : [Incidence_Activity]?
    
    @IBOutlet var topView: UIView!
    @IBOutlet var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackHeightContraints: NSLayoutConstraint!
    let dropDownDirection = DropDown()
    let dropDownDirectionH1 = DropDown()
    @IBOutlet weak var commentTxt: UITextField!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerViewSec: UIView!
    @IBOutlet weak var headerViewSec2: UIView!
    @IBOutlet weak var poetCommentBtn: UIButton!
    @IBOutlet weak var commentCountLbl: UILabel! {
        didSet {
            commentCountLbl.font = commentCountFont
            commentCountLbl.textColor = commentCountColor
        }
    }
    @IBOutlet weak var commentCountLbl2: UILabel! {
        didSet {
            commentCountLbl2.font = commentCountFont
            commentCountLbl2.textColor = commentCountColor
        }
    }
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var statusChangeBtn: UIButton! {
        didSet {
            statusChangeBtn.titleLabel?.font = buttonTitleFont
            statusChangeBtn.titleLabel?.textColor = buttonTitleColor
            statusChangeBtn.backgroundColor = buttonBackgroundColor
        }
    }
    @IBOutlet weak var addDirectionBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton! {
        didSet {
            editBtn.titleLabel?.font = buttonTitleFont
            editBtn.tintColor = buttonTitleColor
            editBtn.backgroundColor = buttonBackgroundColor
        }
    }
    var directionBtn: UIButton!
    @IBOutlet var closeIssueBtn: UIButton! {
        didSet {
            closeIssueBtn.titleLabel?.font = buttonTitleFont
            closeIssueBtn.tintColor = buttonTitleColor
            closeIssueBtn.backgroundColor = buttonBackgroundColor
        }
    }
    @IBOutlet var closeIssueBtnHeight: NSLayoutConstraint!
    
    var ticketIssueTypeArr = [TicketType]()
    var ticketPriorityArr = [TicketType]()
    var DEPARTMENT_ID = ""
    var id = ""
    var isFrom = ""
    var hashTagImage: UIImageView!
    let backButton = UIButton(type: .custom)
    var dateFormatterString: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
        return formatter
    }()
    var currentStatus = ""
    var currentStatusMeaning = ""
    var isFeedback = false
    
    override func viewDidLoad() {
        self.poetCommentBtn.backgroundColor = #colorLiteral(red: 0.0120000001, green: 0.6589999795, blue: 0.275000006, alpha: 1)
        super.viewDidLoad()
        self.addEbotIcone()
        self.addBackButton()
        //        self.tblView.tableFooterView = footerView
        self.closeIssueBtn.isHidden = true
        self.closeIssueBtnHeight.constant = 0
        self.tblView.isHidden = true
        self.collecView.isHidden = true
        self.getTicketDetailsData()
    }
    
    @IBAction func closeIssueClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let obj = storyboard.instantiateViewController(withIdentifier: "ResolutionPopUpVC") as! ResolutionPopUpVC
        obj.delegate = self
        obj.incidentD = self.incidentData
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    func addBackButton() {
        if #available(iOS 16.0, *) {
            self.navigationItem.leftBarButtonItem?.isHidden = false
        } else {
        }
        backButton.setImage(UIImage(named: "IOSback"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func commentSubmitOnServer(){
        if (self.commentTxt.text?.count ?? 0) > 0{
            var params : Parameters = [:]
            params["INCIDENCE_ID"] = self.incidentData?.INCIDENCE_ID ?? ""
            params["PRODUCT_ID"] = self.incidentData?.PRODUCT_ID ?? ""
            params["CUSTOMER_ID"] = ticketResp?.CUSTOMER_ID ?? ""
            let date = DataUtil.convertDateToString(date: Date(), reqFormat: DataUtil.TA_DATE_FORMAT)
            params["COMMENT_DATE"] = date
            params["COMMENT"] = self.commentTxt.text ?? ""
            let postParamHeaders = [String: String]()
            APICommunication.getDataWithGetWithDataResponseTicketModule(url: "addComment", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
                if let cryptoData = successResponseData.data {
                    DataUtil.HideIndictorView()
                    do {
                        let decoder = JSONDecoder()
                        let serviceResponse = try decoder.decode(SaveResponseComment.self, from: cryptoData)
                        if serviceResponse.success == true{
                            if let data = serviceResponse.data {
                                self.commentTxt.text = ""
                            }
                            self.updateCommentCount()
                            self.tblView.reloadData()
                        }
                        
                        else {
                            if let msg = serviceResponse.message{
                                DataUtil.alertMessage(msg, viewController: self)
                            }
                        }
                    } catch let jsonError {
                        DataUtil.HideIndictorView()
                    }
                }
            }) { (dictFailure) in
                if let msg = dictFailure.value(forKey: "message"){
                    DataUtil.HideIndictorView()
                    DataUtil.alertMessage(msg as! String, viewController: self)
                }
                
            }
        }
    }
    
    @IBAction func submitComment(){
        if !(commentTxt.text!.isEmpty) {
            self.commentSubmitOnServer()
        }
    }
    
    @IBAction func backBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTicketDetailsData(){
        let params : Parameters = ["INCIDENCE_ID":self.incidenceId ?? ""]
        let postParamHeaders = [String: String]()
        APICommunication.getDataWithGetWithDataResponseTicketModule(url: "getTicket_IncidenceData", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                DataUtil.HideIndictorView()
                do {
                    let decoder = JSONDecoder()
                    let serviceResponse = try decoder.decode(TicketListResponse.self, from: cryptoData)
                    if serviceResponse.success == true {
                        if let data = serviceResponse.data?.TICKET_LIST{
                            if data.count > 0{
                                self.incidentData = data[0]
                                self.incidenceActivity = data[0].INCIDENCE_ACTIVITY ?? [Incidence_Activity]()
                            }
                            
                            // For Incidence Images
                            if self.incidenceActivity?.count ?? 0 > 0{
                                let arr = self.incidenceActivity?.filter({$0.ACTIVITY_TYPE == "Incidence"})
                                if arr?.count ?? 0 > 0 {
                                    if arr?[0].IMAGE_DETAILS?.count ?? 0 > 0{
                                        self.incidenceActivityIncidenceImages = arr?[0].IMAGE_DETAILS ?? [Image_details]()
                                        self.topView.isHidden = false
                                        self.topViewHeight.constant = 161.0
                                        self.collecView.isHidden = false
                                        self.collecView.reloadData()
                                    } else {
                                        self.topView.isHidden = true
                                        self.topViewHeight.constant = 0.0
                                        self.collecView.isHidden = true
                                        self.collecView.reloadData()
                                    }
                                } else {
                                    self.topView.isHidden = true
                                    self.topViewHeight.constant = 0.0
                                    self.collecView.isHidden = true
                                    self.collecView.reloadData()
                                }
                            } else {
                                self.topView.isHidden = true
                                self.topViewHeight.constant = 0.0
                                self.collecView.isHidden = true
                                self.collecView.reloadData()
                            }
                            
                            // For Incidence Comment/Feedback/Escelation
                            if self.incidenceActivity?.count ?? 0 > 0{
                                let arr = self.incidenceActivity?.filter({($0.ACTIVITY_TYPE == "Comment") || ($0.ACTIVITY_TYPE == "Feedback") || ($0.ACTIVITY_TYPE == "Escalation")})
                                if arr?.count ?? 0 > 0 {
                                    self.incidenceCommentsData = arr
                                }
                            }
                            self.tblView.isHidden = false
                            self.tblView.reloadData()
                            self.updateCommentCount()
                        }
                    }
                    else {
                        if let msg = serviceResponse.message{
                            DataUtil.alertMessage(msg, viewController: self)
                        }
                    }
                } catch let _ {
                    DataUtil.HideIndictorView()
                }
            }
        }) { (dictFailure) in
            if let msg = dictFailure.value(forKey: "message"){
                DataUtil.HideIndictorView()
                DataUtil.alertMessage(msg as! String, viewController: self)
            }
            
        }
    }
    
    func updateCommentCount() {
        var cmnt = ""
        let txt1 = NSLocalizedString("ACTIVITIES", comment: "")
        cmnt = txt1
        if self.incidenceCommentsData?.count ?? 0 == 1 {
            let txt2 = NSLocalizedString("ACTIVITY", comment: "")
            cmnt = txt2
        }
        self.commentCountLbl.text =  "\(self.incidenceCommentsData?.count ?? 0)" + " " + cmnt
        self.commentCountLbl2.text =  "\(self.incidenceCommentsData?.count ?? 0)" + " " + cmnt
    }
    
    @IBAction func testing(_ sender: Any) {
        
    }
    
    func openRemarkPopup(action : String, ttl : String){
        if let data = self.incidentData {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let obj = storyboard.instantiateViewController(withIdentifier: "RemarkPopupVC") as! RemarkPopupVC
            obj.delegate = self
            obj.incidentData = self.incidentData
            obj.request_id = data.INCIDENCE_ID ?? ""
            obj.action = action
            obj.ttl = ttl
            self.navigationController?.present(obj, animated: true, completion: nil)
        }
    }
    
    @IBAction func editClicked(_ sender: Any) {
        self.openRemarkPopup(action: "CANCEL", ttl: "Enter remark to Cancel")
        //        let alert = UIAlertController(title: "  ", message: "Are you want to cancel Ticket?", preferredStyle: UIAlertController.Style.alert)
        //        let image = UIImage(named: "smallLogo")
        //        let imageView = UIImageView(image: image!)
        //        imageView.frame = CGRect(x: 0, y: 0, width: 130, height: 38)
        //        let viewLogo = UIView(frame: CGRect(x: 65, y: 0, width: 130, height: 38))
        //        viewLogo.backgroundColor = .clear
        //        viewLogo.addSubview(imageView)
        //        alert.view.addSubview(viewLogo)
        //        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: {
        //            (action: UIAlertAction!) in
        //
        //        }))
        //        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
        //            self.openRemarkPopup(action: "CANCEL", ttl: "Enter remark to Cancel")
        //        }))
        //
        //        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
        //            if let popoverController = alert.popoverPresentationController {
        //                popoverController.sourceView = self.view
        //                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY-60, width: 0, height: 0)
        //                popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
        //            }
        //        }
        //        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addDirectionClicked(_ sender: Any) {
    }
    
    @IBAction func openResolutionPopup(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let obj = storyboard.instantiateViewController(withIdentifier: "ResolutionPopUpVC") as! ResolutionPopUpVC
        obj.delegate = self
        obj.incidentD = self.incidentData
        obj.isFrom = "comment"
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    func openCommentFeedbcak(type : String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let obj = storyboard.instantiateViewController(withIdentifier: "ResolutionPopUpVC") as! ResolutionPopUpVC
        obj.delegate = self
        obj.incidentD = self.incidentData
        obj.isFrom = type
        obj.ticketPriorityArr = self.ticketPriorityArr
        obj.ticketIssueTypeArr = self.ticketIssueTypeArr
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    func openForm(reopen : Bool){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let obj = story.instantiateViewController(withIdentifier: "ReportIssueVC") as! ReportIssueVC
        obj.isFromDashoBoard = false
        obj.delegate = self
        obj.incidentData = self.incidentData
        obj.isEdit = true
        obj.isReopen = reopen
        obj.ticketIssueTypeArr = self.ticketIssueTypeArr
        obj.ticketPriorityArr = self.ticketPriorityArr
        self.present(obj, animated: true)
    }
    
    @IBAction func statusChangeClicked(_ sender: Any) {
        let txt1 = NSLocalizedString("UPDATE TICKET", comment: "")
        if statusChangeBtn.titleLabel?.text == txt1{
            if let obj = incidentData {
                let updateTicket = NSLocalizedString("UPDATE TICKET", comment: "")
                let feedabck = NSLocalizedString("ADD FEEDBACK", comment: "")
                let cmnt = NSLocalizedString("ADD COMMENT", comment: "")
                let returnT = NSLocalizedString("BACK", comment: "")
                let reopen = NSLocalizedString("REOPEN", comment: "")
                let excalated = NSLocalizedString("ESCALATE", comment: "")
                let closed = NSLocalizedString("CLOSE", comment: "")
                let actionsheet = UIAlertController(title: "", message: updateTicket, preferredStyle: .actionSheet)
                actionsheet.view.tintColor =  UIColor.init(hex: "03A846")
                actionsheet.addAction(UIAlertAction.init(title: returnT, style: .cancel, handler: { (action) in
                }))
                //Every Status except close
                if obj.STATUS != "C"{
                    actionsheet.addAction(UIAlertAction.init(title: cmnt, style: .default, handler: { (action) in
                        self.openCommentFeedbcak(type: "C")
                    }))
                    actionsheet.addAction(UIAlertAction.init(title: feedabck, style: .default, handler: { (action) in
                        self.openCommentFeedbcak(type: "F")
                    }))
                    if obj.STATUS == "9" || obj.STATUS == "6"{
                        actionsheet.addAction(UIAlertAction.init(title: closed, style: .default, handler: { (action) in
                            self.openRemarkPopup(action: "CLOSED", ttl: "Enter remark to Close")
                        }))
                    }
                    if obj.STATUS != "8"{
                        actionsheet.addAction(UIAlertAction.init(title: excalated, style: .default, handler: { (action) in
                            self.openCommentFeedbcak(type: "E")
                        }))
                    }
                }
                //Closed Status
                if obj.STATUS == "C"{
                    actionsheet.addAction(UIAlertAction.init(title: reopen, style: .default, handler: { (action) in
                        self.openForm(reopen: true)
                    }))
                }
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
                    if let popoverController = actionsheet.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY-60, width: 0, height: 0)
                        popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
                    }
                }
                self.present(actionsheet, animated: true, completion: nil)
            }
        } else {
            self.openForm(reopen: true)
        }
    }
    
    func updateStatus(status : String, incident_id : String){
        let params:Parameters = ["REQUEST_ID": incident_id,
                                 "ACTION": status,
                                 "REMARK":"","USER_ID":ticketResp?.CUSTOMER_ID ?? ""]
        let postParamHeaders = [String: String]()
        APICommunication.getDataWithGetWithDataResponseTicketModule(url: "requestApproverAction", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                DataUtil.HideIndictorView()
                do {
                    let decoder = JSONDecoder()
                    let serviceResponse = try decoder.decode(CheckSuccessResponse.self, from: cryptoData)
                    if serviceResponse.success == true {
                        DataUtil.openAlert(title: " ", message: serviceResponse.message ?? "", viewController: self, alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in self.getTicketDetailsData()}])
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
    
    @objc func resolutionViewAction(btn: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let obj = storyboard.instantiateViewController(withIdentifier: "ResolutionDetailsVC") as! ResolutionDetailsVC
        obj.resolutionData = self.incidenceResolutionData
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    func chageStatusCall(){
        if self.incidentData != nil && (self.incidentData!.STATUS == "C" || self.incidentData!.STATUS == "X") {
            statusChangeBtn.isHidden = true
        }
        else {
            statusChangeBtn.isHidden = false
        }
    }
    
    @objc func openDetailScreen(btn: UIButton){
        self.incidenceId = self.incidentData?.REFERENCE_NO ?? ""
        self.getTicketDetailsData()
    }
    
    @available(iOS 15, *)
    func getUrlFromString(text : String)-> NSAttributedString{
        let input = text
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range:NSRange(location: 0, length: input.utf16.count))
        for match in matches {
        guard let range = Range(match.range, in: input) else { continue }
        let url = input[range]
        print(url)
            
            let attributedString = NSMutableAttributedString(string: text, attributes:[NSAttributedString.Key.link: URL(string: String(url))!])
            return attributedString as NSAttributedString

        }
        return NSAttributedString()
    }
    
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
        
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 0.5)
        
        return randomColor
    }
}

extension TicketDetailsVC: UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,updatePreviousListDelegate {
    
    func updatePreviousViewData(data: Any) {
        self.getTicketDetailsData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        } else {
            if self.incidentData != nil && (self.incidentData!.STATUS == "X") {
                return 40
            }
            else {
                self.stackHeightContraints.constant = 40.0
                return 90.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let fView = UIView()
            return fView
        }
        else {
            self.addDirectionBtn.isHidden = true
            if self.incidentData != nil && (self.incidentData!.STATUS == "X") {
                return headerViewSec
            }
            else{
                if self.incidentData != nil && (self.incidentData!.STATUS == "C") {
                    self.editBtn.isHidden = true
                    self.statusChangeBtn.setTitle("REOPEN", for: .normal)
                    self.statusChangeBtn.setTitle("REOPEN", for: .selected)
                    self.statusChangeBtn.setTitle("REOPEN", for: .highlighted)
                }
                else {
                    self.editBtn.isHidden = false
                    self.statusChangeBtn.setTitle("UPDATE TICKET", for: .normal)
                    self.statusChangeBtn.setTitle("UPDATE TICKET", for: .selected)
                    self.statusChangeBtn.setTitle("UPDATE TICKET", for: .highlighted)
                }
                return headerViewSec2
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return self.incidenceCommentsData?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDetailCell", for: indexPath) as! ReportDetailCell
            let obj = self.incidentData
            cell.incidentTypeLbl.text = obj?.INCIDENCE_TYPE_MEANING ?? ""
            if let cont = obj?.UNDER_WARRANTY_CONTRACT{
                var warr = "No"
                if cont == "Y"{
                    warr = "Yes"
                } else {
                    warr = "No"
                }
                cell.warrantyStatusLbl.text = "Under Warranty : \(warr)"
            }
            if let date = obj?.WARRANTY_CONTRACT_EXPIRY_DATE{
                let date = date
                cell.warrantyDateLbl.text = "Warranty Date : \(date)"
            }
            cell.incidenceNoLbl.text = ("TICKET #" + (obj?.INCIDENCE_ID ?? "")) + (" | \(obj?.PRODUCT_NAME ?? "")")
            cell.serialNOLbl.text = obj?.PRODUCT_SERIAL_NUMBER ?? ""
            cell.tankNameLbl.text = obj?.COMMENT
//            self.getUrlFromString(text: obj?.INCIDENCE_DESCRIPTION ?? "")
            cell.descriptionLbl.text = (obj?.INCIDENCE_DESCRIPTION ?? "")
            cell.reportedByLbl.text = "By " + (obj?.CUSTOMER_NAME ?? "")
            if (obj?.INCIDENCE_TYPE ?? "") == "1096"{
                cell.incidenceTypeImgView.image = UIImage(named: "ic_training")
            }
            else if (obj?.INCIDENCE_TYPE ?? "") == "1097"{
                cell.incidenceTypeImgView.image = UIImage(named: "ic_information")
            }
            else {
                cell.incidenceTypeImgView.image = UIImage(named: "ic_issue")
            }
            let time = DataUtil.convertDate(stringDate: obj?.INCIDENCE_DATE ?? "", stringDateFormat: DataUtil.TA_DATE_FORMAT, reqDateFormat: DataUtil.TA_TIME_FORMAT12AMPM)
            let date = DataUtil.convertDate(stringDate: obj?.INCIDENCE_DATE ?? "", stringDateFormat: DataUtil.TA_DATE_FORMAT, reqDateFormat: DataUtil.AMADEUS_DATE)
            cell.dateLbl.text =  date + " AT " + time
            cell.incidentMeaningBtn.setTitle(obj?.INCIDENCE_LEVEL_MEANING ?? "", for: .normal)
            cell.incidentMeaningBtn.setTitle(obj?.INCIDENCE_LEVEL_MEANING ?? "", for: .selected)
            cell.incidentMeaningBtn.setTitle(obj?.INCIDENCE_LEVEL_MEANING ?? "", for: .highlighted)
            if obj?.INCIDENCE_LEVEL == "1098"{
                cell.incidentImgView.image = UIImage(named: "high.png")
            } else if obj?.INCIDENCE_LEVEL == "1099"{
                cell.incidentImgView.image = UIImage(named: "medium.png")
            } else {
                cell.incidentImgView.image = UIImage(named: "low.png")
            }
            cell.statusMeaningBtn.setTitle((obj?.STATUS_MEANING ?? "").uppercased(), for: .normal)
            cell.statusMeaningBtn.setTitle((obj?.STATUS_MEANING ?? "").uppercased(), for: .selected)
            cell.statusMeaningBtn.setTitle((obj?.STATUS_MEANING ?? "").uppercased(), for: .highlighted)
            cell.statusMeaningBtn.tag = indexPath.row
            cell.resolutionView.isHidden = true
            cell.resolutionWidthContraints.constant = 0
            DataUtil.setStatusColors(status: obj?.STATUS ?? "", statusLbl: cell.statusMeaningBtn.titleLabel!, statusView: cell.statusView, statusBTN: cell.statusMeaningBtn)
            // For Resolution
            if obj?.INCIDENCE_ACTIVITY?.count ?? 0 > 0{
                let arr = self.incidenceActivity?.filter({($0.ACTIVITY_TYPE == "Resolution")})
                if arr?.count ?? 0 > 0 {
                    self.incidenceResolutionData = arr
                    cell.resolutionWidthContraints.constant = 32
                    cell.resolutionView.isHidden = false
                } else {
                    cell.resolutionWidthContraints.constant = 0
                    cell.resolutionView.isHidden = true
                }
            }
            cell.resolutionBtn.addTarget(self, action: #selector(resolutionViewAction(btn: )), for: .touchUpInside)
            if let refNo = obj?.REFERENCE_NO{
                cell.refNoBtn.isHidden = false
                cell.refNoHeight.constant = 20.0
                let rf = ("Ref No. : TICKET #\(refNo)")
                let attributedString = NSAttributedString(string: rf, attributes: [
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.refNoBtn.setAttributedTitle(attributedString, for: .normal)
            } else {
                cell.refNoHeight.constant = 0
                cell.refNoBtn.isHidden = true
            }
            cell.refNoBtn.tag = indexPath.row
            cell.refNoBtn.addTarget(self, action: #selector(openDetailScreen(btn: )), for: .touchUpInside)
//            if #available(iOS 15, *) {
//                cell.descriptionLbl.attributedText = self.getUrlFromString(text: obj?.INCIDENCE_DESCRIPTION ?? "")
//            } else {
//                // Fallback on earlier versions
//            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentListCell", for: indexPath) as! CommentListCell
            let obj = self.incidenceCommentsData?[indexPath.row]
            cell.nameLbl.text = obj?.USER_NAME ?? ""
            cell.commentLbl.text = (obj?.ACTIVITY_TYPE ?? "") + " : " + (obj?.DESCRIPTION ?? "")
            
//            if #available(iOS 15, *) {
//                cell.commentLbl.attributedText = (self.getUrlFromString(text: obj?.DESCRIPTION ?? ""))
//            } else {
//                // Fallback on earlier versions
//            }
//
            
            let urlstr = obj?.PROFILE_IMAGE ?? ""
            if let url = URL(string: urlstr ) {
                cell.profileImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"), options: SDWebImageOptions(), completed: nil)
            } else {
                //cell.profileImgView.image = UIImage(named: "avatar")
                let name = obj?.USER_NAME ?? ""
                let nameArray = name.components(separatedBy: " ")
                
                let lblNameInitialize = UILabel()
                lblNameInitialize.frame.size = CGSize(width: 100.0, height: 100.0)
                lblNameInitialize.textColor = UIColor.white
                
                if nameArray.count == 1 {
                    lblNameInitialize.text = String(String(nameArray[0]).first!)
                }
                else if nameArray.count == 2 {
                    lblNameInitialize.text = String(String(nameArray[0]).first!) + String(String(nameArray[1]).first!)
                }
                else if nameArray.count > 2 {
                    lblNameInitialize.text = String(String(nameArray[0]).first!) + String(String(nameArray[1]).first!) + String(String(nameArray[2]).first!)
                }
                let font = UIFont(name: "Poppins-Regular", size: 50)
                lblNameInitialize.font = font
                lblNameInitialize.textAlignment = NSTextAlignment.center
                lblNameInitialize.backgroundColor = generateRandomColor()
                lblNameInitialize.layer.cornerRadius = 50.0

                UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
                lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
                cell.profileImgView.image = UIGraphicsGetImageFromCurrentImageContext()
                cell.profileImgView.layer.borderColor = UIColor.white.cgColor
                cell.profileImgView.layer.borderWidth = 2
                UIGraphicsEndImageContext()
            }
            
            cell.dateTimeLbl.text = obj?.COMMENT_DATE ?? ""//DataUtil.getAgoTime(strDate: obj.COMMENT_DATE ?? "")
            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
            dateComponentsFormatter.maximumUnitCount = 1
            dateComponentsFormatter.unitsStyle = .full
            dateComponentsFormatter.string(from: Date(), to: Date(timeIntervalSinceNow: 4000000))  // "1 month"
            cell.dateTimeLbl.text = DataUtil.getAgoTime(strDate: obj?.COMMENT_DATE ?? "")
            cell.updateCellWith(row: obj?.IMAGE_DETAILS ?? [Image_details]())
            cell.cellDelegate = self
            if obj?.IMAGE_DETAILS?.count ?? 0 > 0{
                cell.mainView.isHidden = false
                cell.mainViewHeight.constant = 80
            } else {
                cell.mainView.isHidden = true
                cell.mainViewHeight.constant = 0
            }
            
            return cell
        }
        
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let obj = self.incidenceActivityIncidenceImages?[indexPath.row]
        if obj?.INCIDENCE_IMAGE_TYPE ?? "" == "59"{
            let vdoStr = obj?.INCIDENCE_IMAGE ?? ""
            let videoURL = URL(string: vdoStr)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else {
            let vdoStr = obj?.INCIDENCE_IMAGE ?? ""
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let obj = storyboard.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            obj.imageUrl = vdoStr
            self.present(obj, animated: true, completion: nil)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.incidenceActivityIncidenceImages?.count ?? 0
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155, height: 155)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "MediaImageListCollecCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MediaImageListCollecCell
        cell.videoIcon.isHidden = true
        let obj = self.incidenceActivityIncidenceImages?[indexPath.row]
        if obj?.INCIDENCE_IMAGE_TYPE ?? "" == "59"{
            cell.videoIcon.isHidden = false
        }
        if let urlStr = obj?.INCIDENCE_IMAGE{
            let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: urlString) {
                let extractedExpr: SDWebImageOptions = SDWebImageOptions()
                cell.imageMedia.sd_setImage(with: url, placeholderImage: UIImage(named: "noImage"), options: extractedExpr, completed: nil)
            }
        }
        else {
            cell.imageMedia.image = UIImage(named: "noImage")
        }
        return cell
    }
}
extension TicketDetailsVC: CollectionViewCellDelegate2 {
    func collectionView2(collectionviewcell: MediaImageListCollecCell3?, index: Int, didTappedInTableViewCell: CommentListCell, data: Image_details) {
        print("You tapped the cell \(index)")
        if data.INCIDENCE_IMAGE_TYPE ?? "" == "59"{
            if let str = data.INCIDENCE_IMAGE{
                let vdoStr = str
                let videoURL = URL(string: vdoStr)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true){
                    playerViewController.player!.play()
                }
            }
        } else {
            if let vdoStr = data.INCIDENCE_IMAGE{
                let stroyboard = UIStoryboard(name: "Main", bundle: nil)
                let obj = stroyboard.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
                obj.imageUrl = vdoStr
                self.present(obj, animated: true, completion: nil)
            }
        }
    }
    
}

class CommentListCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel! {
        didSet {
            nameLbl.font = commentorNameFont
            nameLbl.textColor = commentorNameColor
        }
    }
    @IBOutlet weak var dateTimeLbl: UILabel! {
        didSet {
            dateTimeLbl.font = commentDateLblFont
            dateTimeLbl.textColor = commentDateLblColor
        }
    }
    @IBOutlet weak var commentLbl: UILabel! {
        didSet {
            commentLbl.font = commentLblFont
            commentLbl.textColor = commentLblColor
        }
    }
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentCollecView: UICollectionView!
    weak var cellDelegate: CollectionViewCellDelegate2?
    var imagesData: [Image_details]?
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.commentCollecView.dataSource = self
        self.commentCollecView.delegate = self
    }
}

extension CommentListCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func updateCellWith(row: [Image_details]) {
        self.imagesData = row
        self.commentCollecView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "MediaImageListCollecCell3"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MediaImageListCollecCell3
        cell.videoIcon.isHidden = true
        let obj = self.imagesData?[indexPath.row]
        if obj?.INCIDENCE_IMAGE_TYPE ?? "" == "59"{
            cell.videoIcon.isHidden = false
        }
        if let urlStr = obj?.INCIDENCE_IMAGE{
            let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: urlString) {
                let extractedExpr: SDWebImageOptions = SDWebImageOptions()
                cell.imageMedia.sd_setImage(with: url, placeholderImage: UIImage(named: "noImage"), options: extractedExpr, completed: nil)
            }
        }
        else {
            cell.imageMedia.image = UIImage(named: "noImage")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MediaImageListCollecCell3
        let obj = self.imagesData?[indexPath.row]
        self.cellDelegate?.collectionView2(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self, data: obj ?? Image_details())
    }
}

class ReportDetailCell: UITableViewCell {
    @IBOutlet weak var hashTagImage: UIImageView!
    @IBOutlet var incidenceTypeImgView: UIImageView!
    @IBOutlet weak var incidentTypeLbl: UILabel! {
        didSet {
            incidentTypeLbl.font = issueTypeLblFont
            incidenceNoLbl.textColor = issueTypeLblColor
        }
    }
    @IBOutlet weak var warrantyStatusLbl: UILabel! {
        didSet {
            warrantyStatusLbl.font = underWarrantyStatusFont
            warrantyStatusLbl.textColor = underWarrantyStatusColor
        }
    }
    @IBOutlet weak var warrantyDateLbl: UILabel! {
        didSet {
            warrantyDateLbl.font = underWarrantyDateFont
            warrantyDateLbl.textColor = underWarrantyDateColor
        }
    }
    @IBOutlet var incidenceNoLbl: UILabel! {
        didSet {
            incidenceNoLbl.font = ticketNoLblFont
            incidenceNoLbl.textColor = ticketNoColor
        }
    }
    @IBOutlet var serialNOLbl: UILabel! {
        didSet {
            serialNOLbl.font = srNoLblFont
            serialNOLbl.textColor = srNoLblColor
        }
    }
    @IBOutlet var tankNameLbl: UILabel! {
        didSet {
            tankNameLbl.font = prodNameLblFont
            tankNameLbl.textColor = prodNameLblColor
        }
    }
    @IBOutlet var reportedByLbl: UILabel! {
        didSet {
            reportedByLbl.font = reportedByLblFont
            reportedByLbl.textColor = reportedByLblColor
        }
    }
    @IBOutlet var dateLbl: UILabel! {
        didSet {
            dateLbl.font = reportDateLblFont
            dateLbl.textColor = reportDateLblColor
        }
    }
    @IBOutlet weak var descriptionLbl: UILabel! {
        didSet {
            descriptionLbl.font = descLblFont
            descriptionLbl.textColor = descLblColor
        }
    }
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var incidentImgView: UIImageView!
    @IBOutlet weak var incidentMeaningBtn: UIButton!
    @IBOutlet weak var statusMeaningBtn: UIButton!
    @IBOutlet weak var resolutionBtn: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var resolutionView: UIView!
    @IBOutlet weak var resolutionWidthContraints: NSLayoutConstraint!
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var realTimeBtn: UIButton!
    @IBOutlet weak var realTimeLbl: UILabel!
    
    @IBOutlet var refNoHeight: NSLayoutConstraint!
    @IBOutlet var refNoBtn: UIButton! {
        didSet {
            refNoBtn.titleLabel?.font = referenceBtnFont
            refNoBtn.titleLabel?.textColor = referenceBtnColor
        }
    }

}
class MediaListCell: UITableViewCell {
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var timeSheetReNumLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var taskTypeLbl: UILabel!
    @IBOutlet weak var projectManagerLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var approverView: UIView!
    @IBOutlet weak var showStatusBtn: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
class MediaImageListCollecCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageMedia: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
}
