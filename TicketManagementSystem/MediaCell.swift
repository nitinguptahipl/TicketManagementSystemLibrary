//
//  MediaCell.swift
//  FormView
//
//  Created by HIPL on 19/12/22.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonView: UIButton!

    var buttonTapCallback: () -> ()  = { }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        buttonView.layer.cornerRadius = buttonView.frame.height / 2
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        buttonTapCallback()
    }

}
