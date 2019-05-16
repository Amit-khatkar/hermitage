//
//  HealthStatusVC.swift
//  Hermitage
//
//  Created by Amit on 11/05/19.
//  Copyright © 2019 iamitkhatkar. All rights reserved.
//

import UIKit
import SwiftIconFont
import LBTATools

class HealthStatusVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        setupCard(imgName: "heartbeat", title: "Heart Rate", topPadding: 100)
        setupCard(imgName: "thermometer", title: "Body Temperature", topPadding: 250)
        setupCard(imgName: "heartbeat", title: "Breathing Rate", topPadding: 400)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.title = "Health Status"
    }
    
    func setupCard(imgName: String, title: String, topPadding: CGFloat){
        let icon = UIImageView()
        let card = UIView()
        let titleLabel = UILabel()
        let textfiled = UITextField()
        
        icon.image = UIImage(from: .fontAwesome, code: imgName, textColor: .black, backgroundColor: .clear, size: CGSize(width: 70, height: 70))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textfiled.leftView = indentView
        textfiled.leftViewMode = .always
        textfiled.placeholder = "Enter here"
        
        textfiled.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        textfiled.layer.cornerRadius = 25
        
        card.backgroundColor = .white
        
        card.addSubview(icon)
        card.addSubview(titleLabel)
        card.addSubview(textfiled)
        
        view.addSubview(card)
        
        card.translatesAutoresizingMaskIntoConstraints = false
        card.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
        card.heightAnchor.constraint(equalToConstant: 100).isActive = true
        card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.topAnchor.constraint(equalTo: card.topAnchor, constant: 10).isActive = true
        icon.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: icon.topAnchor, constant: 60).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16).isActive = true
        
        textfiled.translatesAutoresizingMaskIntoConstraints = false
        textfiled.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textfiled.widthAnchor.constraint(equalToConstant: 150).isActive = true
        textfiled.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16).isActive = true
        textfiled.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
        
        
    }
 
}
