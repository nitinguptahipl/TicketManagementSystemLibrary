//
//  ImageDisplayVC.swift
//  FloSenso
//
//  Created by Milan Katiyar on 11/05/23.
//  Copyright © 2023 learning. All rights reserved.
//

import UIKit
import SDWebImage

class ImageDisplayVC: UIViewController {
    
    @IBOutlet weak var displayImg: UIImageView!
    var imageReceipt: UIImage?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayImg.contentMode = .scaleAspectFit
        if let imgUrl = imageUrl {
            print("imgUrl ==",imgUrl)
            let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: urlString ) {
                self.displayImg.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: SDWebImageOptions(), completed: nil)
            }
        }
        else if imageReceipt != nil {
            self.displayImg.image = imageReceipt
        }
    }
    @IBAction func onCross(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
