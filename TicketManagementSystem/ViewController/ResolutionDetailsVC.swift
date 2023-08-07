//
//  ResolutionDetailsVC.swift
//  FloSenso
//
//  Created by Milan Katiyar on 17/05/23.
//  Copyright © 2023 learning. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class ResolutionDetailsVC: UIViewController {
    var resolutionData : [Incidence_Activity]?
    @IBOutlet var tblView: UITableView!
    @IBOutlet var headerLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.estimatedRowHeight = 50
        self.tblView.rowHeight = UITableView.automaticDimension
        
        headerLbl.font = resolutionHeaderTitleFont
        headerLbl.textColor = resolutionHeaderTitleColor
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ResolutionDetailsVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.resolutionData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResolutionCell", for: indexPath) as! ResolutionCell
        let obj = self.resolutionData?[indexPath.section]
        cell.ttlLbl.text = obj?.USER_NAME ?? ""
        cell.resolutionLbl.text = obj?.DESCRIPTION ?? ""
        if obj?.IMAGE_DETAILS?.count ?? 0 > 0{
            cell.mainView.isHidden = false
            cell.mainViewHeight.constant = 120
        } else {
            cell.mainView.isHidden = true
            cell.mainViewHeight.constant = 0
        }
        cell.updateCellWith(row: obj?.IMAGE_DETAILS ?? [Image_details]())
        cell.cellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
}

class MediaImageListCollecCell3: UICollectionViewCell {
    @IBOutlet weak var imageMedia: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
}

class ResolutionCell : UITableViewCell{
    @IBOutlet var bgView: UIView!
    @IBOutlet var resolutionLbl: UILabel!
    @IBOutlet var ttlLbl: UILabel!
    @IBOutlet var mainViewHeight: NSLayoutConstraint!
    @IBOutlet var collecView: UICollectionView!
    @IBOutlet var mainView: UIView!
    weak var cellDelegate: CollectionViewCellDelegate?
    var imagesData: [Image_details]?
    weak var delegate : CollectionViewCellDelegate?
    public override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.shadowColor = UIColor.lightGray.cgColor
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowRadius = 10
        bgView.layer.cornerRadius = 10
        self.collecView.showsHorizontalScrollIndicator = false
        self.collecView.dataSource = self
        self.collecView.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        resolutionLbl.font = resolutionDetailFont
        resolutionLbl.textColor = resolutionDetailColor
        
        ttlLbl.font = resolutionTitleFont
        ttlLbl.textColor = resolutionTitleColor
    }
}

extension ResolutionCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func updateCellWith(row: [Image_details]) {
        self.imagesData = row
        self.collecView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 120)
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
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self, data: obj ?? Image_details())
    }
}

protocol CollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: MediaImageListCollecCell3?, index: Int, didTappedInTableViewCell: ResolutionCell, data : Image_details)
    
}

extension ResolutionDetailsVC: CollectionViewCellDelegate {
    func collectionView(collectionviewcell: MediaImageListCollecCell3?, index: Int, didTappedInTableViewCell: ResolutionCell, data: Image_details) {
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
