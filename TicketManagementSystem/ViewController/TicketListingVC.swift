//
//  TicketListingVC.swift
//  FloSenso
//
//  Created by Milan Katiyar on 04/05/23.
//  Copyright © 2023 learning. All rights reserved.
//

import UIKit
import Alamofire

class TicketListingVC: BaseVC {
    
    let backButton = UIButton(type: .custom)
    @IBOutlet var searchTF: UISearchBar!
    @IBOutlet var searchView: UIView!
    @IBOutlet var tblView: UITableView!
    var ticketListData = [TicketListData]()
    var filteredData = [TicketListData]()
    var incidence_type : [TicketType]?
    var incidence_level : [TicketType]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEbotIcone()
        self.showSearchNotificationIcon()
        self.addBackButton()
        searchTF.delegate = self
        self.tblView.estimatedRowHeight = 300
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.buttonR.addTarget(self, action: #selector(searchClicked(btn:)), for: .touchUpInside)
        self.notifR.addTarget(self, action: #selector(openForm(btn:)), for: .touchUpInside)
        if #available(iOS 13.0, *) {
            searchTF.searchTextField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
        } else {
            if let searchField = self.searchTF.value(forKey: "_searchField") as? UITextField {
                searchField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
            }
        }
        searchTF.showsCancelButton = true
        self.getListData()
    }
    
    func getListData(){
        let params : Parameters = [:]
        let postParamHeaders = [String: String]()
        APICommunication.getDataWithGetWithDataResponseTicketModule(url: "getTicket_IncidenceData", parameter: params, HeaderParams: postParamHeaders, methodType: .post, viewController: self, success: { (successResponseData) in
            if let cryptoData = successResponseData.data {
                DataUtil.HideIndictorView()
                do {
                    let decoder = JSONDecoder()
                    let serviceResponse = try decoder.decode(TicketListResponse.self, from: cryptoData)
                    if serviceResponse.success == true {
                        if let data = serviceResponse.data{
                            let arr = serviceResponse.data?.TICKET_LIST ?? [TicketListData]()
                            self.ticketListData = arr.reversed()//serviceResponse.data!
                            self.filteredData = arr.reversed()//serviceResponse.data!
                            self.incidence_type = serviceResponse.data?.INCIDENCE_TYPE ?? [TicketType]()
                            self.incidence_level = serviceResponse.data?.INCIDENCE_LEVEL ?? [TicketType]()
                            self.tblView.reloadData()
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
    
    @objc func onTextChanged(){
        let text = searchTF.text!
        if text.count>0{
            filterData(text: text);
        }else if text.count == 0{
            ticketListData.removeAll()
            for item in filteredData {
                ticketListData.append(item)
            }
            tblView.reloadData()
        }
    }
    
    func filterData(text : String){
        ticketListData.removeAll()
        let reqArr = filteredData
        let filteredItems = reqArr.filter {(($0.INCIDENCE_ID ?? "").contains(text)) || (($0.INCIDENCE_TYPE_MEANING ?? "").contains(text)) || (($0.INCIDENCE_LEVEL_MEANING ?? "").contains(text)) || (($0.STATUS_MEANING ?? "").contains(text)) || (($0.CUSTOMER_NAME ?? "").contains(text))}
        print("filtered iteme is", filteredItems)
        for item in filteredItems {
            ticketListData.append(item);
        }
        tblView.reloadData()
    }
    
    @objc func openForm(btn:UIButton){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let obj = story.instantiateViewController(withIdentifier: "ReportIssueVC") as! ReportIssueVC
        obj.isFromDashoBoard = false
        obj.delegate = self
        obj.ticketIssueTypeArr = self.incidence_type ?? [TicketType]()
        obj.ticketPriorityArr = self.incidence_level ?? [TicketType]()
        self.present(obj, animated: true)
    }
    
    @objc func searchClicked(btn:UIButton){
        self.tblView.tableHeaderView = nil
        self.tblView.tableHeaderView = searchView
        searchTF.becomeFirstResponder()
        searchTF.showsCancelButton = true
    }
    
    func addBackButton() {
        if #available(iOS 16.0, *) {
            self.navigationItem.leftBarButtonItem?.isHidden = false
        } else {
            // Fallback on earlier versions
        }
        backButton.setImage(UIImage(named: "IOSback"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getWarrantyDate(date : String)-> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AMADEUS_DATE
        let warrantyDate = dateFormatter.date(from: date)
        let currentDate = dateFormatter.date(from: DataUtil.convertDateToString(date: Date(), reqFormat: AMADEUS_DATE))
        if warrantyDate?.compare(currentDate!) == .orderedAscending{
            print("Out of warranty")
            return false
        }
        else {
            print("Under warranty")
            return true
        }
    }
    
    @objc func openDetailScreen(btn: UIButton){
        let data = self.ticketListData[btn.tag]
        let story = UIStoryboard(name: "Main", bundle: nil)
        let obj = story.instantiateViewController(withIdentifier: "TicketDetailsVC") as! TicketDetailsVC
        obj.incidenceId = data.REFERENCE_NO ?? ""
        obj.ticketIssueTypeArr = self.incidence_type ?? [TicketType]()
        obj.ticketPriorityArr = self.incidence_level ?? [TicketType]()
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

extension TicketListingVC : UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, updatePreviousListDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tblView.tableHeaderView = nil
        searchTF.showsCancelButton = false
        searchTF.text = nil
        ticketListData.removeAll()
        for item in filteredData {
            ticketListData.append(item)
        }
        tblView.reloadData()
    }
    
    func updatePreviousViewData(data: Any) {
        if let value = data as? String{
            if value == ""{
                self.getListData()
            } else {
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ticketListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketListCell", for: indexPath) as! TicketListCell
        let data = self.ticketListData[indexPath.row]
        cell.ticketNoLbl.text = ("TICKET #" + (data.INCIDENCE_ID ?? "")) + (" | \(data.PRODUCT_NAME ?? "")")
        cell.issueTypeLbl.text = data.INCIDENCE_TYPE_MEANING ?? ""
        cell.serialNoLbl.text = data.PRODUCT_SERIAL_NUMBER ?? ""
        cell.tankNameLbl.text = data.COMMENT ?? ""
        if let refNo = data.REFERENCE_NO{
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

        if let date = data.WARRANTY_CONTRACT_EXPIRY_DATE, let con = data.UNDER_WARRANTY_CONTRACT{
            let date1 = " (" + date + ")"
            var warr = "No"
            if con == "Y"{
                warr = "Yes"
            } else {
                warr = "No"
            }
            cell.warrantyDateLbl.text = "Under Warranty : \(warr)" + date1
        }
        let time = DataUtil.convertDate(stringDate: data.INCIDENCE_DATE ?? "", stringDateFormat: DataUtil.TA_DATE_FORMAT, reqDateFormat: DataUtil.TA_TIME_FORMAT12AMPM)
        let date = DataUtil.convertDate(stringDate: data.INCIDENCE_DATE ?? "", stringDateFormat: DataUtil.TA_DATE_FORMAT, reqDateFormat: DataUtil.AMADEUS_DATE)
        let targetString = "Reported at : " + date + " AT " + time
        cell.dateLbl.text = targetString
        cell.descriptionLbl.text = data.INCIDENCE_DESCRIPTION ?? ""
        cell.priorityLbl.text = data.INCIDENCE_LEVEL_MEANING ?? ""
        cell.statuLbl.text = (data.STATUS_MEANING ?? "").uppercased()
        DataUtil.setStatusColors(status: data.STATUS ?? "", statusLbl: cell.statuLbl, statusView: cell.statusView, statusBTN: UIButton())
        if data.INCIDENCE_LEVEL == "1098"{
            cell.priorityBtn.setImage(UIImage(named: "high"), for: .normal)
            cell.priorityBtn.setImage(UIImage(named: "high"), for: .selected)
            cell.priorityBtn.setImage(UIImage(named: "high"), for: .highlighted)
        } else if data.INCIDENCE_LEVEL == "1099"{
            cell.priorityBtn.setImage(UIImage(named: "medium"), for: .normal)
            cell.priorityBtn.setImage(UIImage(named: "medium"), for: .selected)
            cell.priorityBtn.setImage(UIImage(named: "medium"), for: .highlighted)
        } else {
            cell.priorityBtn.setImage(UIImage(named: "low"), for: .normal)
            cell.priorityBtn.setImage(UIImage(named: "low"), for: .selected)
            cell.priorityBtn.setImage(UIImage(named: "low"), for: .highlighted)
        }
        if (data.INCIDENCE_TYPE ?? "") == "1096"{
            cell.issueTypeImgView.image = UIImage(named: "ic_training")
        }
        else if (data.INCIDENCE_TYPE ?? "") == "1097"{
            cell.issueTypeImgView.image = UIImage(named: "ic_information")
        }
        else {
            cell.issueTypeImgView.image = UIImage(named: "ic_issue")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let obj = story.instantiateViewController(withIdentifier: "TicketDetailsVC") as! TicketDetailsVC
        obj.incidenceId = self.ticketListData[indexPath.row].INCIDENCE_ID ?? ""
        obj.ticketIssueTypeArr = self.incidence_type ?? [TicketType]()
        obj.ticketPriorityArr = self.incidence_level ?? [TicketType]()
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
}

public class TicketListCell : UITableViewCell{
    @IBOutlet var ticketNoLbl: UILabel!
    @IBOutlet var issueTypeImgView: UIImageView!
    @IBOutlet var issueTypeLbl: UILabel!
    @IBOutlet var serialNoLbl: UILabel!
    @IBOutlet var tankNameLbl: UILabel!
    @IBOutlet var warrantyDateLbl: UILabel!
    @IBOutlet var priorityBtn: UIButton!
    @IBOutlet var priorityLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var statuActionBtn: UIButton!
    @IBOutlet var statuLbl: UILabel!
    @IBOutlet var statusBtn: UIButton!
    @IBOutlet var statusView: UIView!
    @IBOutlet var bgView: UIView!
    
    @IBOutlet var refNoHeight: NSLayoutConstraint!
    @IBOutlet var refNoBtn: UIButton! {
        didSet {
            refNoBtn.contentHorizontalAlignment = .left
        }
    }
    public override func awakeFromNib() {
        bgView.layer.shadowColor = UIColor.lightGray.cgColor
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowRadius = 10
        bgView.layer.cornerRadius = 10
        
        setupUI()
    }
    
    func setupUI() {
        ticketNoLbl.font = ticketNoLblFont
        ticketNoLbl.textColor = ticketNoColor
        
        issueTypeLbl.font = issueTypeLblFont
        issueTypeLbl.textColor = issueTypeLblColor
        
        serialNoLbl.font = srNoLblFont
        serialNoLbl.textColor = srNoLblColor
        
        tankNameLbl.font = prodNameLblFont
        tankNameLbl.textColor = prodNameLblColor
        
        warrantyDateLbl.font = warrantyStatusLblFont
        warrantyDateLbl.textColor = warrantyStatusLblColor
        
        descriptionLbl.font = descLblFont
        descriptionLbl.textColor = descLblColor
        
        dateLbl.font = reportDateLblFont
        dateLbl.textColor = reportDateLblColor
        
        priorityLbl.font = priorityStatusLblFont
        priorityLbl.textColor = priorityStatusLblColor
    }
}

extension UISearchBar {
    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            // Fallback on earlier versions
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
}
