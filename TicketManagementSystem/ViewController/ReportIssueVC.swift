//
//  ReportIssueVC.swift
//  FloSenso
//
//  Created by HIPL on 15/03/23.
//  Copyright © 2023 learning. All rights reserved.
//

import UIKit
import DropDown
import AVFoundation
import Alamofire
import MobileCoreServices

protocol updatePreviousListDelegate: class {
     func updatePreviousViewData(data: Any)
}

class ReportIssueVC: UIViewController {
    
    @IBOutlet var serialNoView: RoundView!
    
    @IBOutlet var attachmentView: RoundView!
    @IBOutlet var serialDropDownImgView: UIImageView!
    
    @IBOutlet var issueDropDownImgView: UIImageView!
    @IBOutlet var selectSerialBtn: UIButton!
    @IBOutlet weak var serialNoTF:UITextField!
    @IBOutlet weak var selectIssueTF:UITextField!
    @IBOutlet weak var descTextView:UITextView!
    @IBOutlet weak var tableViewContent:UIView!
    @IBOutlet weak var tankNameTF:UITextField!
    @IBOutlet weak var warrantyTF:UITextField!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var tableViewContectHeight:NSLayoutConstraint!
    @IBOutlet weak var issueTypeDropDown : UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var serialNoLbl:UILabel!
    @IBOutlet weak var addAttachementLbl:UILabel!
    @IBOutlet weak var descLbl:UILabel!
    @IBOutlet weak var tankNameLbl:UILabel!
    @IBOutlet weak var warrantyLbl:UILabel!
    @IBOutlet var priorityLbl: UILabel!
    @IBOutlet weak var issueTypeLbl:UILabel!
    @IBOutlet weak var headerTtlLbl:UILabel!
    @IBOutlet weak var submitBtn:UIButton!
    @IBOutlet weak var submitBtnView:UIView!

    @IBOutlet var priorityTF: UITextField!
    @IBOutlet var priorityView: RoundView!
    var arrMedia1 = [(UIImage?,NSURL,String,String)]()

    let picker = UIImagePickerController()
    let dropDown = DropDown()
    let dropDownPriority = DropDown()
    let dropDownSerial = DropDown()
    var selectedMacId: String?
    var selectedTankName: String?
    var selectedWarrantyDate: String?
    var selectedSerialNo: String?
    var typeArrTemp = [String]()
    var isFromDashoBoard = true
    var priorityArr = ["Low","Medium","High"]
    var selectedPriority : String?
    var selectedIssue : String?
    var selectedProductName : String?
    var selectedProductId : String?
    var selectedStartDate : String?
    
    var ticketIssueTypeArr = [TicketType]()
    var ticketPriorityArr = [TicketType]()
    weak var delegate : updatePreviousListDelegate!
    
    var reportDescription = false
    var incidentData : TicketListData?
    var isEdit = false
    var isReopen = false
    var callAPI = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.callAPI{
            self.getLookupData()
        }
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        self.setUpData()
        
        //        if reportDescription {
        //            descTextView.text = DataUtil.getString(key: "troubleshootSteps")
        //        }
        
        setupUI()
    }
    
    func setupUI() {
        serialNoLbl.font = RTserialNoLblFont
        serialNoLbl.textColor = RTserialNoLblColor
        
        addAttachementLbl.font = RTaddAttachementLblFont
        addAttachementLbl.textColor = RTaddAttachementLblColor
         
        descLbl.font = RTdescLblFont
        descLbl.textColor = RTdescLblColor
        
        tankNameLbl.font = RTtankNameLblFont
        tankNameLbl.textColor = RTtankNameLblColor
        
        warrantyLbl.font = RTwarrantyLblFont
        warrantyLbl.textColor = RTwarrantyLblColor
        
        priorityLbl.font = RTpriorityLblFont
        priorityLbl.textColor = RTpriorityLblColor
        
        issueTypeLbl.font = RTissueTypeLblFont
        issueTypeLbl.textColor = RTissueTypeLblColor
        
        headerTtlLbl.font = RTHeaderLblFont
        headerTtlLbl.textColor = RTHeaderLblColor
        
        submitBtn.titleLabel?.font = RTButtonFont
        submitBtn.titleLabel?.textColor = RTButtonBtnColor
        submitBtn.backgroundColor = RTButtonBackColor
        submitBtnView.backgroundColor = RTButtonBackColor
        
        headerTtlLbl.font = RTHeaderLblFont
        headerTtlLbl.textColor = RTHeaderLblColor
        
        serialNoTF.font = RTserialNoTFFont
        serialNoTF.textColor = RTserialNoTFColor
        
        selectIssueTF.font = RTissueTypeTFFont
        selectIssueTF.textColor = RTissueTypeTFColor
        
        descTextView.font = RTdescTFFont
        descTextView.textColor = RTdescTFColor
        
        tankNameTF.font = RTtankNameTFFont
        tankNameTF.textColor = RTtankNameTFColor
        
        warrantyTF.font = RTwarrantyTFFont
        warrantyTF.textColor = RTwarrantyTFColor
        
        priorityTF.font = RTpriorityTFFont
        priorityTF.textColor = RTpriorityTFColor
    }
    
    func setDataForEdit(){
        //  params["START_DATE"] = self.selectedStartDate ?? ""
        if self.isEdit == true{
            if let data = self.incidentData{
                self.serialNoTF.text = data.PRODUCT_SERIAL_NUMBER ?? ""
                self.tankNameTF.text = data.COMMENT ?? ""
                self.warrantyTF.text = DataUtil.convertDate(stringDate: data.WARRANTY_CONTRACT_EXPIRY_DATE ?? "", stringDateFormat: DataUtil.AMADEUS_DATE, reqDateFormat: AMADEUS_DATE11)//data.WARRANTY_CONTRACT_EXPIRY_DATE ?? ""
                self.selectIssueTF.text = data.INCIDENCE_TYPE_MEANING ?? ""
                self.priorityTF.text = data.INCIDENCE_LEVEL_MEANING ?? ""
                self.descTextView.text = data.INCIDENCE_DESCRIPTION ?? ""
                self.selectedPriority = data.INCIDENCE_LEVEL ?? ""
                self.selectedIssue = data.INCIDENCE_TYPE ?? ""
                self.selectedProductId = data.PRODUCT_ID ?? ""
                self.selectedSerialNo = data.PRODUCT_SERIAL_NUMBER ?? ""
                self.selectedProductName = data.PRODUCT_NAME ?? ""
                self.selectedWarrantyDate = data.WARRANTY_CONTRACT_EXPIRY_DATE ?? ""
                self.selectedStartDate = "07-06-2023"
                self.serialNoView.isUserInteractionEnabled = false
                self.issueTypeDropDown.isUserInteractionEnabled = false
                self.serialDropDownImgView.isHidden = true
                self.issueDropDownImgView.isHidden = true
                if !isReopen{
                    self.attachmentView.isHidden = true
                }
            }
        }
        self.initializeDropDown()
        self.priorityInitializeDropDown()
    }
    
    func getWarrantyDate(date : String)-> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AMADEUS_DATE11
        let warrantyDate = dateFormatter.date(from: date) // nil
        let currentDate = dateFormatter.date(from: DataUtil.convertDateToString(date: Date(), reqFormat: AMADEUS_DATE11))
        if warrantyDate?.compare(currentDate!) == .orderedAscending{
            print("Warranty Date is smaller then current date")
           return false
        }
        else {
            return true
        }
    }
    
    func setUpData(){
        if isFromDashoBoard{
            self.serialNoView.isUserInteractionEnabled = false
            self.serialDropDownImgView.isHidden = true
            self.serialNoTF.text = selectedSerialNo ?? ""
            self.tankNameTF.text = selectedTankName ?? ""
            self.warrantyTF.text = selectedWarrantyDate ?? ""
        }
        else {
            self.serialNoView.isUserInteractionEnabled = true
            self.serialNoInitializeDropDown()
            
        }
//        self.priorityInitializeDropDown()
        self.setDataForEdit()
        
    }
    
    
    func getLookupData(){
        let params : Parameters = [:]
        let postParamHeaders = [String: String]()
        APICommunication.getDataWithGetWithDataResponseTicketModule(url: "getincidencetypeandlevel", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                DataUtil.HideIndictorView()
                do {
                    let decoder = JSONDecoder()
                    let serviceResponse = try decoder.decode(TicketTypeResponse.self, from: cryptoData)
                    if serviceResponse.success == true {
                        if let data = serviceResponse.data{
                            self.ticketIssueTypeArr = data.INCIDENCE_TYPE ?? [TicketType]()
                            self.ticketPriorityArr = data.INCIDENCE_LEVEL ?? [TicketType]()
                            self.initializeDropDown()
                            self.priorityInitializeDropDown()
                        }
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
    
    @IBAction func attachmentAction(_ sender: UIButton) {
        addAttachment()
    }
    
    
    @IBAction func selectIssueAction(_ sender: UIButton) {
        dropDown.show()
    }
    
    
    @IBAction func selectPriorityAction(_ sender: UIButton) {
        dropDownPriority.show()
    }
    
    @IBAction func selectSerialAction(_ sender: UIButton) {
        dropDownSerial.show()
    }
    
    @IBAction func closeClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
        if validation() {
            saveTicketWithAttachmentVideo()
        }
    }
   
    func saveTicketWithAttachmentVideo(){
        var params : Parameters = [:]
        if isEdit{
            if let id = self.incidentData?.INCIDENCE_ID{
//                params["INCIDENCE_ID"] = id
                if isReopen{
                    params["REFERENCE_NO"] = id
                }
            }
        }
        params["INCIDENCE_LEVEL"] = self.selectedPriority
        params["INCIDENCE_TYPE"] = self.selectedIssue
        params["COMMENT"] = self.tankNameTF.text ?? ""
        if reportDescription {
            let desc = DataUtil.getString(key: "troubleshootSteps")
            params["INCIDENCE_DESCRIPTION"] = desc + (self.descTextView.text ?? "")
        }
        else {
            params["INCIDENCE_DESCRIPTION"] = self.descTextView.text ?? ""
        }
        params["CUSTOMER_ID"] = ticketResp?.CUSTOMER_ID ?? ""
        params["CUSTOMER_NAME"] = ticketResp?.CUSTOMER_NAME ?? ""
        params["CUSTOMER_EMAIL"] = ticketResp?.CUSTOMER_EMAIL ?? ""
        params["CUSTOMER_PHONE"] = ticketResp?.CUSTOMER_PHONE ?? ""
        params["START_DATE"] = self.selectedStartDate ?? ""
        params["PRODUCT_NAME"] = self.selectedProductName//"Water Controller"
        params["PRODUCT_ID"] = self.selectedProductId
        let warranty = self.getWarrantyDate(date: self.selectedWarrantyDate ?? "")
        if warranty {
            params["UNDER_WARRANTY_CONTRACT"] = "Y"
        } else {
            params["UNDER_WARRANTY_CONTRACT"] = "N"
        }
        params["OEM_DEPENDENT"] = "N"
        params["OEM_NAME"] = ""
        params["OEM_TICKET_REFERENCE"] = ""
        
        let date = DataUtil.convertDate(stringDate: self.warrantyTF.text ?? "", stringDateFormat: AMADEUS_DATE11, reqDateFormat: DataUtil.AMADEUS_DATE)
        params["WARRANTY_CONTRACT_EXPIRY_DATE"] = date
        params["PRODUCT_SERIAL_NUMBER"] = self.selectedSerialNo ?? ""
        let date11 = DataUtil.convertDateToString(date: Date(), reqFormat: DataUtil.TA_DATE_FORMAT)
        params["INCIDENCE_DATE"] = date11
        var arrMediaTemp = [(UIImage?,NSURL,String,String)]()
        for itm in arrMedia1{
            if itm.0 == nil{
                
            } else {
                arrMediaTemp.append(itm)
            }
        }
        APICommunication.postPictureAuthorizationHandlerWithVideo(url: "addTicket_IncidenceRequest", postParam: params, mediaArr: arrMediaTemp as! [(UIImage, NSURL, String,String)], viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                do {
                    let decoder = JSONDecoder()
                    let serviceResponse = try decoder.decode(ReportResponse.self, from: cryptoData)
                    if serviceResponse.success == true {
                        if let msg = serviceResponse.message{
                            self.arrMedia1.removeAll()
                            self.alertMessage(msg: msg, isActionReq: true)
//                            if let dele = self.delegate{
//                                dele.updatePreviousViewData(data: "")
//                            }
                        }
                    }
                    else {
                        if let msg = serviceResponse.message{
                            self.alertMessage(msg: msg, isActionReq: false)
                        }
                    }
                    //
                } catch let jsonError {
                    print("jsonError ===",jsonError)
                }
                
                DispatchQueue.main.async {
                    DataUtil.HideIndictorView()
                }
            }
        }) { (dictFailure) in
            if let msg = dictFailure.value(forKey: "message"){
                //                    DataUtil.alertMessage(msg as! String, viewController: self)
                self.alertMessage(msg: msg as! String, isActionReq: false)
                DispatchQueue.main.async {
                    DataUtil.HideIndictorView()
                }
            }
        }
    }
    
    func initializeDropDown(){
        dropDown.anchorView = issueTypeDropDown
        dropDown.direction = .any
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        var tempArr = [String]()
        for itm in self.ticketIssueTypeArr{
            tempArr.append(itm.LOOKUP_MEANING ?? "")
        }
        self.dropDown.dataSource = tempArr
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectIssueTF.text = item
            self.selectedIssue = self.ticketIssueTypeArr[index].LOOKUP_ID ?? ""
        }
    }
    
    func priorityInitializeDropDown(){
        dropDownPriority.anchorView = priorityView
        dropDownPriority.direction = .any
        dropDownPriority.bottomOffset = CGPoint(x: 0, y:(dropDownPriority.anchorView?.plainView.bounds.height)!)
        var tempArr = [String]()
        for item in self.ticketPriorityArr{
            tempArr.append(item.LOOKUP_MEANING ?? "")
        }
        self.dropDownPriority.dataSource = tempArr
        dropDownPriority.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.priorityTF.text = item
            self.selectedPriority = self.ticketPriorityArr[index].LOOKUP_ID ?? ""
        }
    }
    
    func serialNoInitializeDropDown(){
        dropDownSerial.anchorView = serialNoView
        dropDownSerial.direction = .any
        dropDownSerial.bottomOffset = CGPoint(x: 0, y:(dropDownSerial.anchorView?.plainView.bounds.height)!)
//        var tempSerailArr = [String]()
//        for itm in metersDataArr{
//            tempSerailArr.append(itm.SERIAL_NO ?? "")
//        }
//        self.dropDownSerial.dataSource = tempSerailArr
        dropDownSerial.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
//            self.selectIssueTF.text = ""
//            self.selectedIssue = nil
//            let value = metersDataArr[index]
//            self.serialNoTF.text = value.SERIAL_NO ?? ""
//            self.tankNameTF.text = value.EQUIPMENT_SHORT_NAME ?? ""
//            self.warrantyTF.text = value.WARRANTY_EXP_DATE ?? ""
//            self.selectedSerialNo = value.SERIAL_NO ?? ""
//            self.selectedTankName = value.EQUIPMENT_SHORT_NAME ?? ""
//            self.selectedWarrantyDate = value.WARRANTY_EXP_DATE ?? ""
//            self.selectedProductName = value.CATEGORY_SHORT_NAME ?? ""
//            self.selectedProductId = value.EQUIPMENT_CATEGORY_ID ?? ""
//            self.selectedStartDate = value.START_DATE_ACTIVE ?? ""
        }
    }
    
    func validation()->Bool{
        if !(isFromDashoBoard) && self.serialNoTF.text?.count ?? 0 <= 0{
            DataUtil.alertMessageWithoutAction("Please select serial no.", viewController: self)
            return false
        }
        else if selectIssueTF.text?.count ?? 0 <= 0{
            DataUtil.alertMessageWithoutAction("Please select issue type", viewController: self)
            return false
        }
        else if priorityTF.text?.count ?? 0 <= 0{
            DataUtil.alertMessageWithoutAction("Please select priority", viewController: self)
            return false
        }
        else if descTextView.text?.count ?? 0 <= 0{
            DataUtil.alertMessageWithoutAction("Please enter description", viewController: self)
            return false
        }
        else {
            return true
        }
    }
    
    func alertMessage(msg : String, isActionReq : Bool){
        let alert = UIAlertController(title: " ", message:msg, preferredStyle: UIAlertController.Style.alert)
        let image = UIImage(named: "smallLogo")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 130, height: 38)
        let viewLogo = UIView(frame: CGRect(x: 65, y: 0, width: 130, height: 38))
        viewLogo.backgroundColor = .clear
        viewLogo.addSubview(imageView)
        alert.view.addSubview(viewLogo)
        
        alert.addAction(UIAlertAction(title:"OK" , style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            if isActionReq == true{
                self.dismiss(animated: true) {
                }
                if let dele = self.delegate{
                    dele.updatePreviousViewData(data: "")
                }
            } else {
                
            }
            
        }))
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY-60, width: 0, height: 0)
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func addAttachment(){
        let actionsheet = UIAlertController(title: "", message: "Select File", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction.init(title: "From Library", style: .default, handler: { (action) in
            self.selectFromLibrary()
        }))
        actionsheet.addAction(UIAlertAction.init(title: "From Camera", style: .default, handler: { (action) in
            self.selectFromCamera()
        }))
        actionsheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let popoverController = actionsheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY-60, width: 0, height: 0)
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.down;
            }
        }
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    func selectFromLibrary() {
//        picker.allowsEditing = false
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        self.present(picker, animated: true, completion: nil)
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [(kUTTypeMovie as String), (kUTTypeVideo as String),(kUTTypeImage as String)]
        picker.videoMaximumDuration = 300
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func selectFromCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//           // picker.allowsEditing = false
//            picker.sourceType = UIImagePickerController.SourceType.camera
//            picker.cameraCaptureMode = .photo
//            picker.modalPresentationStyle = .fullScreen
//            picker.delegate = self
//            self.present(picker,animated: true,completion: nil)
//        } else {
//            DataUtil.alertMessageWithoutAction("Sorry, this device has no camera", viewController: self)
//        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.mediaTypes = [(kUTTypeMovie as String), (kUTTypeVideo as String),(kUTTypeImage as String)]
            picker.modalPresentationStyle = .fullScreen
            picker.videoMaximumDuration = 300
            self.present(picker,animated: true,completion: nil)
        } else {
            let txt1 = NSLocalizedString("Sorry, this device has no camera", comment: "")
            DataUtil.alertMessageWithoutAction(txt1, viewController: self)
        }
    }
    
    func videoSnapshot(filePathLocal:URL) -> UIImage? {
        do
        {
            let asset = AVURLAsset(url: filePathLocal)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at:CMTimeMake(value: Int64(0), timescale: Int32(1)),actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        }
        catch let error as NSError
        {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
}

extension ReportIssueVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("didFinishPickingMediaWithInfo called")
        if let chosenImage = info[.originalImage] as? UIImage{
            self.arrMedia1.append((chosenImage, NSURL() as NSURL, "image",""))
        }
        else if let videoURL = info[.mediaURL] as? NSURL {
            print(videoURL)
            if let chosenImage = self.videoSnapshot(filePathLocal: videoURL as URL) {
                self.arrMedia1.append((chosenImage, videoURL, "video",""))
            }
        }
        self.imageCollectionView.reloadData()
        picker.dismiss(animated:true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ReportIssueVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.arrMedia1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCell
        cell.imageView.image = self.arrMedia1[indexPath.row].0
        cell.buttonView.tag = indexPath.row
        cell.buttonTapCallback = {
            self.arrMedia1.remove(at: indexPath.row)
            collectionView.reloadData()
        }
        return cell
    }
    
    
}
