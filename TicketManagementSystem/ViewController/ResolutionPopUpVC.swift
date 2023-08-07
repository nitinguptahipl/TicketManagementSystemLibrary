//
//  ResolutionPopUpVC.swift
//  FloSenso
//
//  Created by Milan Katiyar on 15/05/23.
//  Copyright © 2023 learning. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation
import AVKit
import SDWebImage
import Alamofire
import DropDown

class ResolutionPopUpVC: BaseVC {
    var resolutionArray:[Incidence_Resolution_data]?
    var incidentD : TicketListData?
    weak var delegate : updatePreviousListDelegate!
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var textView_desc: UITextView!
    @IBOutlet weak var collecViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tblViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popUpViewHeight: NSLayoutConstraint!
    let picker = UIImagePickerController()
    var arrMedia = [(UIImage?,NSURL,String,String)]()
    var deletedIds = [String]()
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var header_Report: UIView!
    var heightHeader_report: CGFloat = 0.0
    @IBOutlet weak var textViewBGView: UIView!
    @IBOutlet weak var mediaStack: UIStackView!
    @IBOutlet weak var mediaStackHeight: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet var ttlLbl: UILabel!
    
    @IBOutlet var priorityViewHeight: NSLayoutConstraint!
    @IBOutlet var priorityView: UIView!
    
    @IBOutlet var priorityBtn: UIButton!
    @IBOutlet var priorityDropDownImgView: UIImageView!
    @IBOutlet var priorityTF: UITextField!
    @IBOutlet var priorityhdrLbl: UILabel!
    var selectedPriorityId : String?
    let dropDownPriority = DropDown()
    var ticketIssueTypeArr = [TicketType]()
    var ticketPriorityArr = [TicketType]()
    
    var isFrom : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collecView.isHidden = true
        self.collecViewHeight.constant = 0
        self.priorityView.isHidden = true
        self.priorityViewHeight.constant = 0
        popUpViewHeight.constant = 260
        self.textViewBGView.layer.borderColor = UIColor.init(hex: "F8F8F8").cgColor//UIColor.darkGray.cgColor
        self.textViewBGView.layer.borderWidth = 1.0
        //        self.textView_desc.placeholderColor = UIColor.init(hex: "#0558AA")
        //        self.setDataForEdit()
        if isFrom == "C"{
            self.ttlLbl.text = "Add Comment"
            self.submitBtn.setTitle("POST COMMENT", for: .normal)
            self.submitBtn.setTitle("POST COMMENT", for: .selected)
            self.submitBtn.setTitle("POST COMMENT", for: .highlighted)
        } else if isFrom == "F"{
            self.ttlLbl.text = "Add Feedback"
            self.submitBtn.setTitle("POST FEEDBACK", for: .normal)
            self.submitBtn.setTitle("POST FEEDBACK", for: .selected)
            self.submitBtn.setTitle("POST FEEDBACK", for: .highlighted)
        }
        else if isFrom == "N"{
            self.ttlLbl.text = "Add Note"
            self.submitBtn.setTitle("POST NOTE", for: .normal)
            self.submitBtn.setTitle("POST NOTE", for: .selected)
            self.submitBtn.setTitle("POST NOTE", for: .highlighted)
        }
        else if isFrom == "E"{
            self.ttlLbl.text = "Escalate"
            self.submitBtn.setTitle("ESCALATE", for: .normal)
            self.submitBtn.setTitle("ESCALATE", for: .selected)
            self.submitBtn.setTitle("ESCALATE", for: .highlighted)
            self.priorityViewHeight.constant = 60
            self.priorityView.isHidden = false
            popUpViewHeight.constant = 320
            self.priorityTF.text = self.incidentD?.INCIDENCE_LEVEL_MEANING ?? ""
            self.selectedPriorityId = self.incidentD?.INCIDENCE_LEVEL ?? ""
            self.priorityInitializeDropDown()
//            self.priorityhdrLbl.isHidden = true
        }
        setupUI()
    }
    
    func setupUI() {
        ttlLbl.font = popUpTitleFont
        ttlLbl.textColor = popUpTitleColor
        
        submitBtn.titleLabel?.font = popUpButtonFont
        submitBtn.titleLabel?.textColor = popUpButtonColor
        submitBtn.backgroundColor = popUpButtonBackColor
        
        priorityTF.font = changePriorityTextFont
        priorityTF.textColor = changePriorityTextColor
        
        priorityhdrLbl.font = changePriorityLblFont
        priorityhdrLbl.textColor = changePriorityLblColor
        
        textView_desc.font = descTextViewFont
        textView_desc.textColor = descTextViewColor
    }
    
    func setDataForEdit(){
        if let obj = incidentD{
            for itm in obj.INCIDENCE_IMAGES ?? [Incidence_Images_Data](){
                if itm.INCIDENCE_IMAGE_TYPE ?? "" == "59"{
                    let urlStr = itm.INCIDENCE_IMAGE ?? ""
                    let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    if let url = URL(string: urlString) {
                        self.arrMedia.append((nil,url as NSURL,"video",itm.INCIDENCE_IMAGE_ID ?? ""))
                    }
                } else {
                    let urlStr = itm.INCIDENCE_IMAGE ?? ""
                    let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    if let url = URL(string: urlString) {
                        self.arrMedia.append((nil,url as NSURL,"image",itm.INCIDENCE_IMAGE_ID ?? ""))
                    }
                }
            }
            if (self.resolutionArray ?? [Incidence_Resolution_data]()).count > 0 {
                self.textView_desc.isEditable = false
                self.mediaStack.isHidden = true
                self.mediaStackHeight.constant = 0
                self.submitBtn.isHidden = true
            }
        }
        if self.arrMedia.count > 0{
            self.collecView.isHidden = false
            self.collecViewHeight.constant = 120
            self.view.layoutIfNeeded()
            self.collecView.reloadData()
        }
        
    }
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func deleteImage(btn: UIButton){
        self.arrMedia.remove(at: btn.tag)
        if arrMedia.count > 0{
            self.view.layoutIfNeeded()
            self.collecView.reloadData()
        } else {
            self.collecView.isHidden = true
            self.collecViewHeight.constant = 0
            popUpViewHeight.constant = 260
            if self.isFrom == "E"{
                popUpViewHeight.constant = 320
            }
            self.view.layoutIfNeeded()
            self.collecView.reloadData()
        }
    }
    @IBAction func attachClicked(_ sender: Any) {
        self.selectFromLibrary()
    }
    
    
    @IBAction func cameraClicked(_ sender: Any) {
        self.selectFromCamera()
    }
    
    @IBAction func selectPriority(_ sender: Any) {
        dropDownPriority.show()
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
            self.selectedPriorityId = self.ticketPriorityArr[index].LOOKUP_ID ?? ""
        }
    }
    
    
    @IBAction func selectFromLibrary() {
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [(kUTTypeMovie as String), (kUTTypeVideo as String),(kUTTypeImage as String)]
        picker.videoMaximumDuration = 300
        self.present(picker, animated: true, completion: nil)
        
    }
    @IBAction func selectFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.mediaTypes = [(kUTTypeMovie as String), (kUTTypeVideo as String),(kUTTypeImage as String)]
            picker.modalPresentationStyle = .fullScreen
            picker.videoMaximumDuration = 300
            picker.delegate = self
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
    @IBAction func attachmentClicked(_ sender: UIButton) {
        self.storeDataOnServer(requestType: "SUBMIT")
    }
    func validation() -> Bool{
        if self.textView_desc.text == "" || self.textView_desc.text.isEmpty {
            DataUtil.alertMessageWithoutAction("Plese enter description", viewController: self)
            return false
        }
        return true
    }
    
    func storeDataOnServer(requestType:String){
        var params : Parameters = [:]
        if let incId = incidentD?.INCIDENCE_ID{
            params["INCIDENCE_ID"] = incId
            params["INCIDENCE_LEVEL"] = incidentD?.INCIDENCE_LEVEL ?? ""
            params["INCIDENCE_TYPE"] = incidentD?.INCIDENCE_TYPE ?? ""
            params["PRODUCT_ID"] = incidentD?.PRODUCT_ID ?? ""
            params["PRODUCT_SERIAL_NUMBER"] = incidentD?.PRODUCT_SERIAL_NUMBER ?? ""
        }
        params["ACTIVITY_TYPE"] = self.isFrom ?? "R"
        let date = DataUtil.convertDateToString(date: Date(), reqFormat: DataUtil.TA_DATE_FORMAT)
        params["ACTIVITY_DATE"] = date
        params["DESCRIPTION"] = self.textView_desc.text ?? ""
        params["USER_ID"] = ticketResp?.CUSTOMER_ID ?? ""
        if isFrom == "E"{
            params["INCIDENCE_LEVEL"] = selectedPriorityId ?? ""
        }
        let postParamHeaders = [String: String]()
        var arrMediaTemp = [(UIImage?,NSURL,String,String)]()
        for itm in arrMedia{
            if itm.0 == nil{
                
            } else {
                arrMediaTemp.append(itm)
            }
        }
        APICommunication.postPictureAuthorizationHandlerWithVideoTwo(url: "addTicket_Activity", postParam: params, mediaArr: arrMediaTemp as! [(UIImage, NSURL, String,String)], viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                do {
                    let decoder = JSONDecoder()
                    let serviceResponse = try decoder.decode(ReportResponse.self, from: cryptoData)
                    if serviceResponse.success == true {
                        if let msg = serviceResponse.message{
                            self.arrMedia.removeAll()
                            DataUtil.openAlert(title: " ", message: msg, viewController: self, alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                                self.dismiss(animated: true)
                                if let dele = self.delegate{
                                    dele.updatePreviousViewData(data: "")
                                }
                            }])
                        }
                    }
                    else {
                        if let msg = serviceResponse.message{
                            DataUtil.alertMessageWithoutAction(msg, viewController: self)
                        }
                    }
                } catch let jsonError {
                    print("jsonError ===",jsonError)
                }
                
                DispatchQueue.main.async {
                    DataUtil.HideIndictorView()
                }
            }
        }) { (dictFailure) in
            if let msg = dictFailure.value(forKey: "message"){
                DataUtil.alertMessageWithoutAction(msg as! String, viewController: self)
                DispatchQueue.main.async {
                    DataUtil.HideIndictorView()
                }
            }
        }
    }
    
}
extension ResolutionPopUpVC:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,updatePreviousListDelegate {
    
    
    func updatePreviousViewData(data: Any) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMedia.count
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 120)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mediaType = self.arrMedia[indexPath.row]
        let identifier = "MediaImageListCollecCell2"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MediaImageListCollecCell2
        if mediaType.2 == "image"{
            cell.videoIcon.isHidden = true
        }
        else  if mediaType.2 == "video"{
            cell.videoIcon.isHidden = false
        }
        if mediaType.0 == nil{
            cell.imageMedia.sd_setImage(with: mediaType.1 as URL, placeholderImage: UIImage(named: "noImage"), options: SDWebImageOptions(), completed: nil)
        } else {
            cell.imageMedia.image = mediaType.0
        }
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteImage(btn:)), for: .touchUpInside)
        if (self.resolutionArray ?? [Incidence_Resolution_data]()).count > 0 {
            cell.deleteButton.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("didFinishPickingMediaWithInfo called")
        if let chosenImage = info[.originalImage] as? UIImage{
            self.arrMedia.append((chosenImage, NSURL() as NSURL, "image",""))
        }
        else if let videoURL = info[.mediaURL] as? NSURL {
            print(videoURL)
            if let chosenImage = self.videoSnapshot(filePathLocal: videoURL as URL) {
                self.arrMedia.append((chosenImage, videoURL, "video",""))
            }
        }
        self.collecView.isHidden = false
        self.collecViewHeight.constant = 120
        popUpViewHeight.constant = 380
        if self.isFrom == "E"{
            popUpViewHeight.constant = 440
        }
        self.view.layoutIfNeeded()
        self.collecView.reloadData()
        picker.dismiss(animated:true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


class MediaImageListCollecCell2: UICollectionViewCell {
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet weak var imageMedia: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
}
