//
//  BaseVC.swift
//  EnergyBots
//
//  Created by HIPL-GLOBYLOG on 9/12/19.
//  Copyright © 2019 learning. All rights reserved.
//

import UIKit
import Alamofire

class BaseVC: UIViewController {
    var buttonR: UIButton!
    var notifR: UIButton!
    var buttonL: UIButton!
    var imageView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.addEbotIconeOnNavBar()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor =  UIColor.init(hex: greenColor)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setTitleColor()
    }
    func setTitleColor() {
        let selectedColor   = UIColor(red: 31.0/255.0, green: 170.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let font = UIFont .systemFont(ofSize: 9)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }

    func addEbotIconeOnNavBar(){
        let logo = UIImage(named: "smallLogo")
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 38))
        imageView.image = logo
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 38))
        vw.addSubview(imageView)
         self.tabBarController?.navigationItem.titleView = vw
    }
      func addEbotIcone(){
        let logo = UIImage(named: "smallLogo")
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 38))
        imageView.image = logo
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 38))
        vw.addSubview(imageView)
         self.navigationItem.titleView = vw
     }
     func removeLogoIcon(){
        self.tabBarController?.navigationItem.titleView = nil
    }
    
    func showSearchNotificationIcon(){
        buttonR = UIButton(type: .custom)
        buttonR.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        buttonR.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        buttonR.setImage(UIImage(named: "search"), for: .normal)
        buttonR.setImage(UIImage(named: "search"), for: .selected)
        buttonR.setImage(UIImage(named: "search"), for: .highlighted)
        
        //..................................
        
        notifR = UIButton(type: .custom)
        notifR.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        notifR.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        notifR.setImage(#imageLiteral(resourceName: "plus_btn"), for: .normal)
        notifR.setImage(#imageLiteral(resourceName: "plus_btn"), for: .selected)
        notifR.setImage(#imageLiteral(resourceName: "plus_btn"), for: .highlighted)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 40))
        let viewNotif = UIView(frame: CGRect(x: 50, y: 0, width: 40, height: 40))
        viewNotif.addSubview(notifR)
        view.addSubview(buttonR)
        view.addSubview(viewNotif)
        
        let barButton = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItem = barButton
    }

}
