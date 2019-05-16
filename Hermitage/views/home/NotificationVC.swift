//
//  NotificationVC.swift
//  Hermitage
//
//  Created by Amit on 11/05/19.
//  Copyright © 2019 iamitkhatkar. All rights reserved.
//

import UIKit
import SwiftIconFont

class NotificationVC: UIViewController {
    
    let newUpdateLabel = UILabel()
    let connectLabel = UILabel()
    let bluetoothImage = UIImageView()
    let card = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          self.tabBarController?.title = "Notifications"
    }
    
    func setupView(){
        newUpdateLabel.text = "New Updates"
        newUpdateLabel.font = newUpdateLabel.font.withSize(30)
        connectLabel.text = "Connect Your Device"
        bluetoothImage.image =  UIImage(from: .materialIcon, code: "bluetooth", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        card.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        
        view.addSubview(newUpdateLabel)
        
        card.addSubview(connectLabel)
        card.addSubview(bluetoothImage)
        view.addSubview(card)
        
        newUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        newUpdateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        newUpdateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        card.translatesAutoresizingMaskIntoConstraints = false
        card.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        card.heightAnchor.constraint(equalToConstant: 45).isActive = true
        card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        connectLabel.translatesAutoresizingMaskIntoConstraints = false
        connectLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20).isActive = true
        connectLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor, constant: 0).isActive = true
        
        bluetoothImage.translatesAutoresizingMaskIntoConstraints = false
        bluetoothImage.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20).isActive = true
        bluetoothImage.centerYAnchor.constraint(equalTo: card.centerYAnchor, constant: 0).isActive = true
        
    }
    



}
